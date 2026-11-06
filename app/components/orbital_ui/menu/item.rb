# frozen_string_literal: true

module OrbitalUi
  class Menu
    class Item < Component
      include OrbitalUi::Concerns::IconProp

      attribute :url, :string, default: nil
      attribute :disabled, :boolean, default: false
      attribute :selected, :boolean, default: false
      attribute :active, :boolean, default: false
      attribute :destructive, :boolean, default: false
      attribute :modal, :any, default: nil
      attribute :shortcut, :string, default: nil
      attribute :icon, :any, default: nil

      renders_one :icon_slot, OrbitalUi::Icon

      def call
        content_tag tag_name, **html_attributes do
          safe_join([
            render_icon,
            icon_slot,
            content_tag(:span, content, class: "Orbital-Menu-Item-Content"),
            (@shortcut ? render(OrbitalUi::Text.new(size: :sm, tone: :subdued)) { @shortcut } : nil),
            check_icon
          ].compact)
        end
      end

      private

      def check_icon
        content_tag(
          :svg,
          class: "Orbital-Menu-Item-Check", width: "16", height: "16", viewBox: "0 0 24 24",
          fill: "none", stroke: "currentColor", "stroke-width": "2",
          "stroke-linecap": "round", "stroke-linejoin": "round"
        ) do
          tag.polyline(points: "20 6 9 17 4 12")
        end
      end

      def tag_name
        @url.present? ? :a : :button
      end

      def default_attributes
        attrs = super.merge(
          class: "Orbital-Menu-Item",
          role: "menuitem",
          tabindex: "-1",
          "data-disabled": @disabled || nil,
          "data-selected": @selected || nil,
          "data-active": @active || nil,
          "data-destructive": @destructive || nil,
          "aria-disabled": @disabled ? "true" : nil,
          "data-orbital-menu-target": "item"
        )

        attrs[:href] = @url if @url.present?
        attrs[:type] = "button" unless @url.present?

        if @modal.is_a?(String) && %w[true false].exclude?(@modal)
          attrs["data-open-modal"] = @modal
        elsif @modal && @url.present?
          attrs["data-turbo-frame"] = OrbitalUi.configuration.dialog_portal_id
        end

        attrs
      end
    end
  end
end
