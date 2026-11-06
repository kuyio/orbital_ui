# frozen_string_literal: true

module OrbitalUi
  # Wraps +form_with+. Fields written as <Form:TextField name="email"/> get their name, id, value,
  # label and error from the model, and render where they're written, so they work inside layouts.
  class Form < Component
    attribute :model, :any, default: nil
    attribute :scope, :string, default: nil
    attribute :url, :any, default: nil
    attribute :format, :string, default: nil
    attribute :method, :symbol, default: nil
    attribute :builder, :any, default: nil
    attribute :gap, :string, default: "4"

    def call
      form_with(**form_options) { content }
    end

    def method_missing(name, ...)
      return form_builder.public_send(name, ...) if name.start_with?("with_")

      super
    end

    def respond_to_missing?(name, include_private = false)
      name.start_with?("with_") || super
    end

    private

    def form_options
      {
        model: @model,
        scope: @scope,
        url: @url,
        format: @format,
        method: @method,
        builder: builder_class,
        html: html_attributes
      }.compact
    end

    def form_builder
      @form_builder ||= builder_class.new(object_name, record, __vc_original_view_context, {})
    end

    def builder_class
      @builder || Form::Builder
    end

    def record
      @model.is_a?(::Array) ? @model.last : @model
    end

    def object_name
      return @scope if @scope
      return unless record

      record.to_model.model_name.param_key
    end

    def default_attributes
      super.merge(class: "Orbital-Form", "data-gap": @gap)
    end
  end
end
