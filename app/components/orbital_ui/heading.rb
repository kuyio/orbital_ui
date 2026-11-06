# frozen_string_literal: true

class OrbitalUi::Heading < OrbitalUi::Component
  attribute :size, :string, only: %w[xs sm md lg xl 2xl 3xl 4xl], default: "md"
  attribute :weight, :symbol, only: %i[light normal medium semibold bold], default: :semibold
  attribute :align, :symbol, only: %i[left center right], default: :left
  attribute :tone, :symbol, only: %i[default subdued], default: :default
  attribute :as, :string, default: "span"

  def call
    content_tag @as, **html_attributes do
      content
    end
  end

  private

  def default_attributes
    super.merge(
      class: class_names(
        'Orbital-Heading',
        size_classes,
        weight_classes
      ),
      "data-tone": @tone,
      "data-align": @align
    )
  end

  def size_classes
    case @size
    when 'xs'
      "text-heading-xs"
    when 'sm'
      "text-heading-sm"
    when 'md'
      "text-heading-md"
    when 'lg'
      "text-heading-lg"
    when 'xl'
      "text-heading-xl"
    when '2xl'
      "text-heading-2xl"
    when '3xl'
      "text-heading-3xl"
    when '4xl'
      "text-heading-4xl"
    end
  end

  def weight_classes
    case @weight
    when :light
      "font-light"
    when :normal
      "font-normal"
    when :medium
      "font-medium"
    when :semibold
      "font-semibold"
    when :bold
      "font-bold"
    end
  end
end
