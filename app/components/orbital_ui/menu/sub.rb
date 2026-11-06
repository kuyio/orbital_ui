# frozen_string_literal: true

module OrbitalUi
  class Menu
    class Sub < Component
      include OrbitalUi::Concerns::IconProp

      attribute :label, :string, required: true
      attribute :icon, :any, default: nil

      renders_many :items, types: {
        item: { renders: Menu::Item, as: :item },
        label: { renders: Menu::Label, as: :label },
        separator: { renders: Menu::Separator, as: :separator }
      }

      def call
        content_tag(:div, **html_attributes) do
          safe_join([trigger_button, sub_content])
        end
      end

      private

      def trigger_button
        content_tag(:button,
          class: "Orbital-Menu-Item Orbital-Menu-Sub-Trigger",
          role: "menuitem",
          tabindex: "-1",
          "aria-haspopup": "true",
          "aria-expanded": "false",
          "data-orbital-menu-target": "item",
          "data-orbital-menu-sub-target": "trigger",
          "data-action": "click->orbital-menu-sub#toggle") do
          safe_join([
            render_icon,
            content_tag(:span, @label, class: "Orbital-Menu-Item-Content"),
            render(OrbitalUi::Icon.new(name: "chevron-right", size: :sm, class: "Orbital-Menu-Sub-Icon"))
          ].compact)
        end
      end

      def sub_content
        content_tag(:div,
          class: "Orbital-Menu-Sub-Content",
          role: "menu",
          "data-orbital-menu-sub-target": "content",
          "data-action": "keydown->orbital-menu-sub#handleKeydown") do
          safe_join(items)
        end
      end

      def expanded
        @expanded || "false"
      end

      def default_attributes
        super.merge(
          class: "Orbital-Menu-Sub",
          "data-state": "closed",
          data: {
            controller: "orbital-menu-sub"
          }
        )
      end
    end
  end
end
