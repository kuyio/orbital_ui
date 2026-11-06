# frozen_string_literal: true

module OrbitalUi
  module Components
    module Styles
      extend ActiveSupport::Concern

      ##
      # Join the given style names together
      #
      # This implementation follows the same pattern as the `class_names` method
      # however, it does not split the values by spaces.
      #
      def style_names(*args)
        styles = build_style_names(*args).flat_map { |value| CGI.unescape_html(value.to_s) }.uniq
        safe_join(styles.push(''), ";")
      end

      private

      def build_style_names(*args)
        values = []
        args.each do |arg|
          case arg
          when Hash
            arg.each do |k, v|
              values << k if v && k.present?
            end
          when Array
            values.concat build_style_names(*arg)
          else
            values << arg.to_s if arg.present?
          end
        end

        values
      end
    end
  end
end
