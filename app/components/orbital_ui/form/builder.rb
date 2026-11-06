# frozen_string_literal: true

module OrbitalUi
  class Form
    # Bridges a model and Orbital's field components. Any with_text_field style call renders the
    # matching component, found through ORB.namespaces and then OrbitalUi, so an app can override one.
    class Builder < ActionView::Helpers::FormBuilder
      def render_field(component, **opts, &)
        name = opts[:name]&.to_s
        bind(opts, name) if name
        emit component.new(**opts), &
      end

      def with_check_box(name:, unchecked_value: "0", **opts, &)
        name = name.to_s
        opts[:checked] = ActiveModel::Type::Boolean.new.cast(value_for(name)) unless opts.key?(:checked)
        opts[:name] = name
        bind(opts, name, value: false)
        @template.concat @template.hidden_field_tag(opts[:name], unchecked_value, id: nil)
        emit resolve("CheckBox").new(**opts), &
      end

      def with_submit(**opts, &)
        emit resolve("Button").new(type: :submit, **opts), &
      end

      def with_hidden_field(name:, **opts, &_block)
        @template.concat hidden_field(name.to_s, **opts)
      end

      def with_fields(name:, values:, **opts, &)
        @template.concat fields_for(name.to_s, values, builder: self.class, **opts, &)
      end

      def method_missing(name, **opts, &)
        return super unless name.start_with?("with_")

        render_field(resolve(name.to_s.delete_prefix("with_").camelize), **opts, &)
      end

      def respond_to_missing?(name, include_private = false)
        name.start_with?("with_") || super
      end

      private

      def emit(component, &)
        @template.concat @template.render(component, &)
      end

      def bind(opts, name, value: true)
        opts[:error] = error_for(name) unless opts.key?(:error)
        opts[:label] = name.humanize unless opts.key?(:label)
        opts[:value] = value_for(name) if value && !opts.key?(:value) && opts[:type].to_s != "password"
        return unless object_name.present?

        opts[:name] = field_name(name)
        opts[:id] = field_id(name) unless opts.key?(:id)
      end

      def value_for(name)
        object.public_send(name) if object.respond_to?(name)
      end

      def error_for(name)
        object.errors.full_messages_for(name.to_sym).first if object.respond_to?(:errors)
      end

      def resolve(name)
        namespaces = (ORB.namespaces + ["OrbitalUi"]).uniq

        namespaces.each do |namespace|
          component = "#{namespace}::#{name}".safe_constantize
          return component if component.is_a?(Class)
        end

        raise NameError, "No component `#{name}` found in namespaces: #{namespaces.join(', ')}."
      end
    end
  end
end
