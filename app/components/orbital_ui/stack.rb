# frozen_string_literal: true

module OrbitalUi
  class Stack < Component
    attribute :gap, :string, default: "4"
    attribute :align, :symbol, default: :stretch, only: %i[start center end stretch]
    attribute :justify, :symbol, default: :start, only: %i[start center end between around evenly]
    attribute :padding, :string
    attribute :dividers, :boolean, default: false

    orb_template <<-ORB
      <div **html_attributes>{{content}}</div>
    ORB

    private

    def default_attributes
      attrs = super.merge(
        class: "Orbital-Stack",
        "data-gap": @gap,
        "data-align": @align,
        "data-justify": @justify,
        "data-padding": @padding
      )
      attrs[:"data-dividers"] = true if @dividers
      attrs
    end
  end
end
