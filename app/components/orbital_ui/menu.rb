# frozen_string_literal: true

module OrbitalUi
  class Menu < Component
    renders_many :menu_items, types: {
      item: { renders: Menu::Item, as: :item },
      label: { renders: Menu::Label, as: :label },
      separator: { renders: Menu::Separator, as: :separator },
      sub: { renders: Menu::Sub, as: :sub }
    }

    attribute :orientation, :symbol, default: :vertical, only: [:vertical, :horizontal]

    orb_template <<-ORB
      <div **html_attributes>
        {#for menu_item in menu_items}
          {{menu_item}}
        {/for}
      </div>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-Menu",
        role: "menu",
        "data-orientation": @orientation,
        data: {
          controller: "orbital-menu",
          action: "keydown->orbital-menu#handleKeydown"
        }
      )
    end
  end
end
