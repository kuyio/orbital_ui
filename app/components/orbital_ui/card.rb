# frozen_string_literal: true

module OrbitalUi
  class Card < Component
    renders_one :header, Card::Header
    renders_one :footer, Card::Footer

    attribute :gap, :string
    attribute :padding, :string

    orb_template <<-ORB
      <div **html_attributes>
        {{header}}
        <div **content_attributes>{{content}}</div>
        {{footer}}
      </div>
    ORB

    private

    # A splat, because a bound attribute on an HTML tag would render nil as data-gap="".
    def content_attributes
      { class: "Orbital-Card-Content", "data-gap": @gap, "data-padding": @padding }
    end

    def default_attributes
      super.merge(class: "Orbital-Card")
    end
  end
end
