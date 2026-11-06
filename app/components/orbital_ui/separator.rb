# frozen_string_literal: true

module OrbitalUi
  class Separator < Component
    attribute :orientation, :symbol, only: %i[horizontal vertical], default: :horizontal
    attribute :decorative, :boolean, default: true

    orb_template <<-ORB
      <div **html_attributes></div>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-Separator",
        "data-orientation": @orientation,
        role: @decorative ? "none" : "separator"
      )
    end
  end
end
