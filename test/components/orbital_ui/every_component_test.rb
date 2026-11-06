# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  # Generates a render test for every component and slot under app/components, so new ones
  # are covered automatically. Add an entry below if one needs arguments to render.
  class EveryComponentTest < ActiveSupport::TestCase
    ROOT = File.expand_path("../../../app/components", __dir__)
    RAW_TEMPLATE_SYNTAX = /\{\{|\{%|\*\*html_attributes|:if=|:for=/

    ARGUMENTS = {
      "OrbitalUi::Accordion::Item" => { value: "one" },
      "OrbitalUi::Form" => { url: "/" },
      "OrbitalUi::Icon" => { name: "check" },
      "OrbitalUi::Image" => { src: "/photo.jpg" },
      "OrbitalUi::Menu::Sub" => { label: "More" }
    }.freeze

    # These render their own slots or markup, and ignore a block.
    IGNORES_BLOCK = %w[
      OrbitalUi::Card::Header
      OrbitalUi::Icon
      OrbitalUi::Menu::Separator
      OrbitalUi::Menu::Sub
    ].freeze

    COMPONENTS = Dir.glob("**/*.rb", base: ROOT)
      .grep_v(%r{\Aorbital_ui/component\.rb\z|/concerns/|/builder\.rb\z})
      .map { |path| path.delete_suffix(".rb").camelize.constantize }
      .sort_by(&:name)
      .freeze

    # Returns [setter, renderable] for each way of filling a slot. A polymorphic slot has one per type.
    def self.slot_setters(slot, definition)
      if definition[:renderable_hash]
        definition[:renderable_hash].map { |type, type_definition| ["with_#{type}", type_definition[:renderable]] }
      else
        name = definition[:collection] ? slot.to_s.singularize : slot
        [["with_#{name}", definition[:renderable]]]
      end
    end

    # The component's initializer consumes the hash it's given, so each call gets a copy.
    def arguments_for(klass)
      ARGUMENTS.fetch(klass&.name, {}).dup
    end

    def render(component)
      request_view_context.render(component) { "content" }.to_s
    end

    def assert_rendered_html(html)
      assert_predicate html.strip, :present?, "rendered nothing"
      assert_no_match RAW_TEMPLATE_SYNTAX, html
      assert_empty Nokogiri::HTML5.fragment(html, max_errors: 5).errors.map(&:message), "invalid HTML: #{html}"
    end

    test "finds every component" do
      assert_operator COMPONENTS.size, :>=, 48
      assert_includes COMPONENTS, Card::Header
      assert_not_includes COMPONENTS, Component
    end

    COMPONENTS.each do |klass|
      test "#{klass.name} renders" do
        assert_rendered_html render(klass.new(arguments_for(klass)))
      end

      klass.registered_slots.each do |slot, definition|
        slot_setters(slot, definition).each do |setter, renderable|
          test "#{klass.name} #{setter} renders" do
            component = klass.new(arguments_for(klass))
            component.public_send(setter, **arguments_for(renderable)) { "slot content" }
            html = render(component)

            assert_rendered_html html
            assert_includes html, "slot content" unless IGNORES_BLOCK.include?(renderable&.name)
          end
        end
      end
    end

    test "no component defines an attribute twice" do
      COMPONENTS.each do |klass|
        names = klass.attribute_definitions.pluck(:name)

        assert_equal names.uniq, names, "#{klass.name} has duplicate attribute definitions"
      end
    end

    test "a redefined attribute keeps the caller's value" do
      popcard = Popcard.new(position: :s, on: :click)

      assert_equal :s, popcard.attr_position
      assert_equal :click, popcard.attr_on
    end

    test "a redefined attribute uses the subclass default" do
      popcard = Popcard.new

      assert_equal :n, popcard.attr_position
      assert_equal :hover, popcard.attr_on
    end

    test "redefining an attribute does not change the parent" do
      popover = Popover.new

      assert_equal :auto, popover.attr_position
      assert_equal :click, popover.attr_on
    end

    test "Expander applies vertical and custom classes" do
      html = render(Expander.new(vertical: true, class: "custom", id: "spacer"))

      assert_includes html, "Orbital-Expander--vertical"
      assert_includes html, "custom"
      assert_includes html, 'id="spacer"'
    end

    test "Expander is horizontal by default" do
      html = render(Expander.new)

      assert_includes html, 'class="Orbital-Expander"'
      assert_not_includes html, "--vertical"
    end

    test "CheckBox keeps its input attributes without an end tag" do
      html = render(CheckBox.new(name: "terms", checked: true, disabled: true))

      assert_match(/<input[^>]*name="terms"/, html)
      assert_match(/<input[^>]*checked/, html)
      assert_match(/<input[^>]*disabled/, html)
      assert_not_includes html, "</input>"
    end
  end
end
