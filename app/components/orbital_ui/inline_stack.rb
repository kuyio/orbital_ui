# frozen_string_literal: true

module OrbitalUi
  class InlineStack < Component
    attribute :gap, :string, default: "4"
    attribute :align, :symbol, default: :stretch, only: %i[start center end stretch]
    attribute :justify, :symbol, default: :start, only: %i[start center end between around evenly]
    attribute :padding, :string
    attribute :wrap, :string

    orb_template <<-ORB
      <div **html_attributes>{{content}}</div>
    ORB

    private

    def default_attributes
      attrs = super.merge(
        class: "Orbital-InlineStack",
        "data-gap": @gap,
        "data-align": @align,
        "data-justify": @justify,
        "data-padding": @padding
      )
      if @wrap
        attrs[:"data-wrap"] = @wrap == "reverse" ? "reverse" : true
      end
      attrs
    end
  end
end
