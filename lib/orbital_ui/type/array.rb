# frozen_string_literal: true

module OrbitalUi
  module Type
    class Array < ActiveModel::Type::Value
      def type
        :array
      end

      def serialize(value)
        value.to_json
      end

      private

      def cast_value(value)
        if value.is_a?(::Array)
          value
        elsif value.is_a?(::String)
          JSON.parse(value)
        else
          []
        end
      end
    end
  end
end
