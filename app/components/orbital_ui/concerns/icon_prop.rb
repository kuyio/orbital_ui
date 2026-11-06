# frozen_string_literal: true

module OrbitalUi
  module Concerns
    module IconProp
      def render_icon(icon = @icon, size: :sm)
        return nil unless icon

        opts = icon.is_a?(Hash) ? { size: size }.merge(icon) : { name: icon, size: size }
        render(OrbitalUi::Icon.new(**opts))
      end
    end
  end
end
