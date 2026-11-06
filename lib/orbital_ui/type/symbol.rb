# frozen_string_literal: true

module OrbitalUi
  module Type
    class Symbol < ActiveModel::Type::Value
      def type
        :symbol
      end

      private

      def cast_value(value)
        value.to_s.to_sym
      end
    end
  end
end
