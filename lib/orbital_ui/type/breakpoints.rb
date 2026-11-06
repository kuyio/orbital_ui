# frozen_string_literal: true

module OrbitalUi
  module Type
    class Breakpoints < ActiveModel::Type::Value
      def type
        :breakpoints
      end

      BREAKPOINTS = %w[xs sm md lg xl].freeze
      BREAKPOINTS_REGEX = /((xs|sm|md|lg|xl)\s*:\s*[0-9]+,?)+/

      def serialize(value)
        value.map do |breakpoint, val|
          "#{breakpoint}:#{val}"
        end.join(',')
      end

      private

      def cast_value(value)
        if value.is_a?(::Hash)
          value.select { |k, _v| BREAKPOINTS.include?(k.to_s) }
        elsif value.is_a?(::String) && value.match?(BREAKPOINTS_REGEX)
          cast_from_string(value)
        elsif value.is_a?(::Integer) || (value.is_a?(::String) && value.match?(/\A[0-9]+\z/))
          { xs: value }
        else
          {}
        end
      end

      def cast_from_string(value)
        result = {}
        return result unless value.is_a?(::String) && value.present?

        value.split(',').each do |pair|
          breakpoint, val = pair.split(':').map(&:strip)
          result[breakpoint.to_sym] = val if BREAKPOINTS.include?(breakpoint)
        end

        result
      end
    end
  end
end
