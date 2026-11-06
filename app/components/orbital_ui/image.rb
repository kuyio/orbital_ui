# frozen_string_literal: true

class OrbitalUi::Image < OrbitalUi::Component
  attribute :asset, :string
  attribute :src, :string
  attribute :alt, :string, default: ""
  attribute :width, :integer, default: 32
  attribute :height, :integer, default: 32

  def initialize(kwargs = {})
    super
    return if @asset.present? ^ @src.present?

    raise ArgumentError, "Image requires exactly one of :asset or :src"
  end

  def call
    tag.img(src: @src.presence || asset_path(@asset), alt: @alt, width: @width, height: @height, **html_attributes)
  end

  private

  def default_attributes
    super.merge(class: 'Orbital-Image')
  end
end
