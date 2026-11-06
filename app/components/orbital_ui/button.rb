# frozen_string_literal: true

module OrbitalUi
  class Button < Component
    attribute :variant, :symbol, default: :default, only: [:default, :destructive, :outline, :secondary, :ghost, :link]
    attribute :size, :symbol, default: :default, only: [:sm, :default, :lg, :icon]
    attribute :url, :string, default: nil
    attribute :disabled, :boolean, default: false
    attribute :fullwidth, :boolean, default: false
    attribute :modal, :any, default: nil

    def call
      build_tag(**html_attributes) do
        content
      end
    end

    private

    def default_attributes
      attrs = super.merge(
        class: "Orbital-Button",
        "data-variant": @variant,
        "data-size": @size,
        "data-disabled": @disabled || nil,
        "data-fullwidth": @fullwidth || nil
      )

      if @modal.is_a?(String) && %w[true false].exclude?(@modal)
        attrs["data-open-modal"] = @modal
      elsif @modal && @url.present?
        attrs["data-turbo-frame"] = OrbitalUi.configuration.dialog_portal_id
      end

      attrs
    end

    def build_tag(**opts)
      if @url.present?
        tag.a(href: @url, **opts) { yield }
      else
        tag.button(**opts) { yield }
      end
    end
  end
end
