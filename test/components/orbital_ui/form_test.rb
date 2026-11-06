# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class FormTest < ActiveSupport::TestCase
    class Account
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :email, :string
      attribute :password, :string
      attribute :plan_id, :integer
      attribute :active, :boolean

      validates :email, presence: true

      def persisted? = false
    end

    class Page < OrbitalUi::Component
      attribute :account, :any

      orb_template <<~ORB
        <Form model={@account} url="/accounts" id="account" class="custom" data-turbo="false" gap="2">
          <Grid columns="2" id="layout">
            <Form:TextField name="email"/>
            <Form:TextField name="password" type="password"/>
          </Grid>
          <Form:Select name="plan_id" options={[{label: "Free", value: 1}, {label: "Pro", value: 2}]}/>
          <Form:CheckBox name="active"/>
          <Form:HiddenField name="plan_id"/>
          <Form:Submit>Save</Form:Submit>
        </Form>
      ORB
    end

    class UrlOnlyPage < OrbitalUi::Component
      orb_template <<~ORB
        <Form url="/search" method="get">
          <Form:TextField name="query" label="Search" value="hats"/>
        </Form>
      ORB
    end

    def parse(component)
      Nokogiri::HTML5.fragment(request_view_context.render(component).to_s)
    end

    def page(**attributes)
      account = Account.new(**attributes)
      account.valid?
      parse(Page.new(account: account))
    end

    test "fills fields from the model" do
      input = page(email: "sam@example.com").at_css('input[type="text"]')

      assert_equal "sam@example.com", input["value"]
      assert_match(/\[email\]\z/, input["name"])
      assert_match(/_email\z/, input["id"])
    end

    test "labels fields from the name" do
      assert_includes page.text, "Email"
      assert_includes page.text, "Plan"
    end

    test "shows validation errors" do
      assert_includes page.text, "Email can't be blank"
      assert_not_includes page(email: "sam@example.com").text, "can't be blank"
    end

    test "never renders a password value" do
      input = page(email: "a@example.com", password: "secret").at_css('input[type="password"]')

      assert_nil input["value"]
      assert_match(/\[password\]\z/, input["name"])
    end

    test "fields render where they are written, inside layouts" do
      grid = page.at_css("#layout")

      assert_equal 2, grid.css("input").size
      assert_nil page.at_css('form > .Orbital-Field input[type="password"]')
    end

    test "fields render in the order they are written, inside the form" do
      form = page.at_css("form")

      assert_equal 1, form.css("#layout").size
      assert form.at_css('button[type="submit"]')
      assert_equal "Save", form.at_css('button[type="submit"]').text.strip
    end

    test "passes html attributes to the form" do
      form = page.at_css("form")

      assert_equal "account", form["id"]
      assert_equal "/accounts", form["action"]
      assert_equal "false", form["data-turbo"]
      assert_equal "2", form["data-gap"]
      assert_includes form["class"], "Orbital-Form"
      assert_includes form["class"], "custom"
    end

    test "selects the model's value, including an integer" do
      fragment = page(plan_id: 2)
      hidden = fragment.at_css('input.Orbital-Select-Input')

      assert_equal "2", hidden["value"]
      assert_includes fragment.at_css(".Orbital-Select").text, "Pro"
    end

    test "a check box reflects the model and sends a value when unchecked" do
      checked = page(active: true).at_css('input[type="checkbox"]')
      unchecked = page(active: false).at_css('input[type="checkbox"]')

      assert checked.key?("checked")
      assert_not unchecked.key?("checked")
      assert_equal "1", checked["value"]
      hidden = page.css('input[type="hidden"]').find { |input| input["name"] == checked["name"] }

      assert_equal "0", hidden["value"]
    end

    test "explicit attributes win" do
      component = Class.new(OrbitalUi::Component) do
        attribute :account, :any

        def self.name = "ExplicitPage"

        orb_template <<~ORB
          <Form model={@account} url="/x">
            <Form:TextField name="email" label="Your email" value="x@example.com" error="Nope" id="mine"/>
          </Form>
        ORB
      end
      fragment = parse(component.new(account: Account.new(email: "sam@example.com")))
      input = fragment.at_css("input#mine")

      assert_equal "x@example.com", input["value"]
      assert_includes fragment.text, "Your email"
      assert_includes fragment.text, "Nope"
    end

    test "works without a model" do
      form = parse(UrlOnlyPage.new).at_css("form")
      input = form.at_css('input[name="query"]')

      assert_equal "/search", form["action"]
      assert_equal "get", form["method"]
      assert_equal "hats", input["value"]
    end

    test "an unknown field raises a clear error" do
      builder = Form::Builder.new(nil, nil, request_view_context, {})

      error = assert_raises(NameError) { builder.with_flux_capacitor(name: "x") }

      assert_includes error.message, "FluxCapacitor"
      assert_includes error.message, "OrbitalUi"
    end
  end
end
