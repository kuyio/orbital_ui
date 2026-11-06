# frozen_string_literal: true

module OrbitalUi
  class Card
    class Footer < Component
      orb_template <<-ORB
        <div **html_attributes>{{content}}</div>
      ORB

      private

      def default_attributes
        super.merge(class: "Orbital-Card-Footer")
      end
    end
  end
end
