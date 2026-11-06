# frozen_string_literal: true

module OrbitalUi
  class Menu
    class Separator < Component
      orb_template <<-ORB
        <div **html_attributes></div>
      ORB

      private

      def default_attributes
        super.merge(
          class: "Orbital-Menu-Separator",
          role: "separator",
          "aria-orientation": "horizontal"
        )
      end
    end
  end
end
