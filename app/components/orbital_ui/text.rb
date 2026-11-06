# frozen_string_literal: true

class OrbitalUi::Text < OrbitalUi::Component
  SIZE_CLASSES = { xs: "text-body-xs", sm: "text-body-sm", lg: "text-body-lg", xl: "text-body-xl" }.freeze
  WEIGHT_CLASSES = { light: "font-light", medium: "font-medium", semibold: "font-semibold", bold: "font-bold" }.freeze

  attribute :size, :symbol, only: %i[xs sm md lg xl], default: :md
  attribute :weight, :symbol, only: %i[light normal medium semibold bold], default: :normal
  attribute :align, :symbol, only: %i[left center right], default: :left
  attribute :tone, :symbol, only: %i[default subdued success warning danger info magic], default: :default
  attribute :as, :string, default: "span"

  def call
    content_tag @as, **html_attributes do
      content
    end
  end

  private

  def default_attributes
    attrs = super.merge(
      class: class_names(
        'Orbital-Text',
        size_classes,
        weight_classes
      )
    )
    attrs[:"data-tone"] = @tone unless @tone == :default
    attrs[:"data-align"] = @align unless @align == :left
    attrs
  end

  def size_classes
    SIZE_CLASSES[@size]
  end

  def weight_classes
    WEIGHT_CLASSES[@weight]
  end
end
