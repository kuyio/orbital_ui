# frozen_string_literal: true

module OrbitalUi
  class ButtonGroup < Component
    attribute :orientation, :symbol, default: :horizontal, only: [:horizontal, :vertical]

    orb_template <<-ORB
      <div **html_attributes>{{content}}</div>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-ButtonGroup",
        "data-orientation": @orientation
      )
    end
  end
end
