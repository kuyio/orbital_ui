# frozen_string_literal: true

module OrbitalUi
  class Typography < Component
    TAG_MAPPING = {
      h1: :h1,
      h2: :h2,
      h3: :h3,
      h4: :h4,
      p: :p,
      blockquote: :blockquote,
      list: :ul,
      lead: :p,
      large: :div,
      small: :small,
      muted: :p
    }.freeze

    attribute :variant, :symbol, default: :p, only: TAG_MAPPING.keys

    def call
      content_tag(tag_name, content, **html_attributes)
    end

    private

    def tag_name
      TAG_MAPPING[@variant] || :p
    end

    def default_attributes
      super.merge(
        class: "Orbital-Typography",
        "data-variant": @variant
      )
    end
  end
end
