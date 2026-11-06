# frozen_string_literal: true

module OrbitalUi
  class Card
    class Content < Component
      orb_template <<-ORB
        <div **html_attributes>{{content}}</div>
      ORB

      private

      def default_attributes
        super.merge(class: "Orbital-Card-Content")
      end
    end
  end
end
