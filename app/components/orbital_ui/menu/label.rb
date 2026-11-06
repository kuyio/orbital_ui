# frozen_string_literal: true

module OrbitalUi
  class Menu
    class Label < Component
      orb_template <<-ORB
        <div **html_attributes>{{content}}</div>
      ORB

      private

      def default_attributes
        super.merge(
          class: "Orbital-Menu-Label",
          role: "presentation"
        )
      end
    end
  end
end
