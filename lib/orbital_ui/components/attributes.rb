# frozen_string_literal: true

module OrbitalUi
  module Components
    module Attributes
      extend ActiveSupport::Concern

      using OrbitalUi::AttributeUtils

      included do
        ActiveModel::Type.register(:any, OrbitalUi::Type::Any)
        ActiveModel::Type.register(:array, OrbitalUi::Type::Array)
        ActiveModel::Type.register(:symbol, OrbitalUi::Type::Symbol)
        ActiveModel::Type.register(:breakpoints, OrbitalUi::Type::Breakpoints)
      end

      module ClassMethods
        ##
        # Define an attribute for the component
        #
        # Example:
        #   attribute :label, :string, default: 'More'
        #
        # @param name [Symbol] the name of the attribute
        # @param type [Symbol] the type of the attribute
        # @param default [Object] the default value of the attribute
        # @param options [Hash] additional options for the attribute
        def attribute(name, type = nil, default: nil, **options)
          # A redefined attribute replaces the inherited one. If both stayed, initialize would
          # process it twice, and the second pass would reset the caller's value to the default.
          attribute_definitions.reject! { |definition| definition[:name] == name }
          attribute_definitions << { name: name, type: type, default: default, **options }
        end

        ##
        # Used to store the attribute definitions for the component
        def attribute_definitions
          @attribute_definitions ||= if superclass.respond_to?(:attribute_definitions)
                                       superclass.attribute_definitions.dup
                                     else
                                       []
                                     end
        end
      end

      def initialize(kwargs = {})
        # Set the default values for the attributes, or the values passed in the keyword arguments
        self.class.attribute_definitions.each do |definition|
          name = definition[:name]
          default_value = __default_value_for_attribute_definition(definition)
          raw_value = kwargs.delete(name)

          raise "Missing required attribute :#{name}" if raw_value.nil? && definition[:required]

          value = ActiveModel::Type.lookup(definition[:type]).cast(raw_value)

          # Assign the default value to a new instance variable
          instance_variable_set(:"@#{name}", default_value)

          # Define a getter method for the attribute
          define_singleton_method(:"attr_#{name}") { instance_variable_get(:"@#{name}") }

          # Assign the value passed in the keyword arguments to the instance variable if possible
          next if value.nil?

          if definition[:only]&.exclude?(value)
            if definition[:unknown] == :raise
              raise ArgumentError, "Invalid value for attribute #{name}: #{value.inspect}"
            end

            next

          end
          instance_variable_set(:"@#{name}", value)
        end

        # All remaining keyword arguments are stored in the @unmatched_attributes instance variable
        instance_variable_set(:@unmatched_attributes, kwargs)
      end

      ##
      # Returns the default attributes of the component as a hash
      #
      def default_attributes
        {}
      end

      ##
      # Returns the HTML attributes of the component as a hash
      def html_attributes
        __flatten_attributes(default_attributes.merge_html_attributes(@unmatched_attributes).deep_tidy)
      end

      ##
      # Returns the attributes of the component as a hash
      #
      # @param include_options [Boolean] whether to include the options in the result
      # @param flattened [Boolean] whether to flatten the result
      # @return [Hash] the attributes of the component
      def attrs(include_options: false, flattened: false)
        result = {}
        self.class.attribute_definitions.each do |definition|
          name = definition[:name]
          value = instance_variable_get(:"@#{name}")
          result[name] = value
        end

        result.merge!(@unmatched_attributes || {}) if include_options
        if flattened
          __flatten_attributes(result)
        else
          result
        end
      end

      ##
      # Returns the options of the component as a hash
      #
      # The options are the keyword arguments passed to the component that were not
      # matched against the defined attributes.
      #
      # @param flattened [Boolean] whether to flatten the result
      # @return [Hash] the options of the component
      def options(flattened: true)
        result = @unmatched_attributes || {}
        if flattened
          __flatten_attributes(result)
        else
          result
        end
      end

      private

      def __default_value_for_attribute_definition(definition)
        default_value = definition.fetch(:default, nil)
        return default_value if default_value.nil?

        default_value = default_value.call if default_value.respond_to?(:call)
        default_value
      end

      def __flatten_attributes(attributes)
        flattened = {}

        attributes.each do |key, value|
          case value
          when Hash
            __flatten_attributes(value).each do |k, v|
              if k.nil?
                flattened[key] = v
              else
                flattened["#{key}-#{k.to_s.tr('_', '-')}"] = v
              end
            end
          else
            flattened[key] = value if value
          end
        end
        flattened
      end
    end
  end
end
