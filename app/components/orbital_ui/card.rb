# frozen_string_literal: true

module OrbitalUi
  class Card < Component
    renders_one :header, Card::Header
    renders_one :footer, Card::Footer

    orb_template <<-ORB
      <div **html_attributes>
        {{header}}
        <div class="Orbital-Card-Content">{{content}}</div>
        {{footer}}
      </div>
    ORB

    private

    def default_attributes
      super.merge(class: "Orbital-Card")
    end
  end
end
