# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  # test_helper loads only `orbital_ui`, as an app does when its Gemfile lists nothing else,
  # so these fail if the gem stops loading its own template engine.
  class OrbRenderingTest < ActiveSupport::TestCase
    def render(component)
      ActionController::Base.new.view_context.render(component) { "hello" }.to_s
    end

    def test_badge_renders_html_rather_than_template_source
      html = render(Badge.new)

      assert_includes html, 'class="Orbital-Badge"'
      assert_includes html, "hello"
      assert_not_includes html, "html_attributes"
    end

    def test_card_renders_html_rather_than_template_source
      html = render(Card.new)

      assert_includes html, 'class="Orbital-Card"'
      assert_not_includes html, "html_attributes"
    end

    def test_stack_renders_html_rather_than_template_source
      html = render(Stack.new)

      assert_includes html, 'class="Orbital-Stack"'
      assert_not_includes html, "html_attributes"
    end
  end
end
