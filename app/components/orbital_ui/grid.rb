# frozen_string_literal: true

module OrbitalUi
  class Grid < Component
    attribute :columns, :string, default: "1"
    attribute :gap, :string, default: "4"

    orb_template <<-ORB
      <div **html_attributes>{{content}}</div>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-Grid",
        "data-columns": @columns,
        "data-gap": @gap
      )
    end
  end
end
