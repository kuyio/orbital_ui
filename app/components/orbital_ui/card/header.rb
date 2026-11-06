# frozen_string_literal: true

module OrbitalUi
  class Card
    class Header < Component
      renders_one :title, Card::Title
      renders_one :description, Card::Description
      renders_one :action, Card::Action

      orb_template <<-ORB
        <div **html_attributes>
          {{title}}
          {{description}}
          {{action}}
        </div>
      ORB

      private

      def default_attributes
        super.merge(class: "Orbital-Card-Header")
      end
    end
  end
end
