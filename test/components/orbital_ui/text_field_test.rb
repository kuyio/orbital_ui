# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class TextFieldTest < ActiveSupport::TestCase
    def render(**attributes)
      ActionController::Base.new.view_context.render(TextField.new(attributes)).to_s
    end

    def input_in(html)
      Nokogiri::HTML5.fragment(html).at_css("input, textarea")
    end

    test "forwards unknown attributes to the input" do
      input = input_in(render(name: "amount", min: "1", step: "0.01", "aria-label": "Amount", data: { action: "go" }))

      assert_equal "1", input["min"]
      assert_equal "0.01", input["step"]
      assert_equal "Amount", input["aria-label"]
      assert_equal "go", input["data-action"]
    end

    test "uses a given id for the input and its label" do
      html = render(id: "amount", label: "Amount")

      assert_equal "amount", input_in(html)["id"]
      assert_includes html, 'for="amount"'
    end

    test "generates an id when none is given, and uses it for the label" do
      html = render(label: "Amount")
      id = input_in(html)["id"]

      assert_match(/\Ainput-/, id)
      assert_includes html, %(for="#{id}")
    end

    test "merges a given class with the input's own classes" do
      classes = input_in(render(class: "custom"))["class"]

      assert_includes classes, "custom"
      assert_includes classes, "pl-2"
    end

    test "keeps its own input attributes" do
      input = input_in(render(type: "email", name: "email", value: "a@example.com", required: true, placeholder: "You"))

      assert_equal "email", input["type"]
      assert_equal "email", input["name"]
      assert_equal "a@example.com", input["value"]
      assert_equal "You", input["placeholder"]
      assert input.key?("required")
      assert_not input.key?("disabled")
    end

    test "multiline renders its value as content" do
      textarea = input_in(render(name: "notes", multiline: 3, value: "Hello", data: { action: "go" }))

      assert_equal "textarea", textarea.name
      assert_equal "Hello", textarea.text
      assert_not textarea.key?("value")
      assert_equal "3", textarea["rows"]
      assert_equal "go", textarea["data-action"]
    end
  end
end
