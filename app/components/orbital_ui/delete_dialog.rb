# frozen_string_literal: true

module OrbitalUi
  class DeleteDialog < Component
    attribute :open, :boolean, default: false
    attribute :dismissible, :boolean, default: true
    attribute :size, :symbol, default: :default, only: [:sm, :default, :lg, :xl, :full]
    attribute :title, :string, default: "Delete item?"
    attribute :description, :string, default: nil
    attribute :cancel_text, :string, default: "Cancel"
    attribute :confirm_text, :string, default: "Delete"
    attribute :action_url, :string, default: nil
    attribute :method, :symbol, default: :delete, only: [:get, :post, :patch, :put, :delete]
    attribute :loading, :boolean, default: false
    attribute :destructive, :boolean, default: true

    renders_one :cancel_action
    renders_one :confirm_action

    def call
      render OrbitalUi::Modal.new(open: @open, dismissible: @dismissible, size: @size, **html_attributes) do
        content_tag(:div, class: "Orbital-Dialog", "data-destructive": @destructive || nil) do
          safe_join([
            dismissible_close_button,
            header_section,
            body_section,
            footer_section
          ].compact)
        end
      end
    end

    private

    def dismissible_close_button
      return nil unless @dismissible

      content_tag(:button, type: "button", data: { action: "orbital-modal#close" },
        class: "Orbital-Dialog-Close", "aria-label": "Close") do
        close_icon
      end
    end

    def close_icon
      tag.svg(class: "Orbital-Icon", width: "16", height: "16", viewBox: "0 0 24 24",
        fill: "none", stroke: "currentColor", "stroke-width": "2",
        "stroke-linecap": "round", "stroke-linejoin": "round") do
        safe_join([
          tag.line(x1: "18", y1: "6", x2: "6", y2: "18"),
          tag.line(x1: "6", y1: "6", x2: "18", y2: "18")
        ])
      end
    end

    def header_section
      content_tag(:div, class: "Orbital-Dialog-Header") do
        content_tag(:div) do
          safe_join([
            content_tag(:h2, @title, class: "Orbital-Dialog-Title"),
            (@description ? content_tag(:p, @description, class: "Orbital-Dialog-Description") : nil)
          ].compact)
        end
      end
    end

    def body_section
      return nil unless content?

      content_tag(:div, content, class: "Orbital-Dialog-Body")
    end

    def footer_section
      if @action_url
        form_footer
      else
        div_footer
      end
    end

    def form_footer
      content_tag(:form, action: @action_url, method: "post", class: "Orbital-Dialog-Footer") do
        safe_join([
          csrf_hidden_field,
          method_hidden_field,
          cancel_button,
          confirm_button(:submit)
        ].compact)
      end
    end

    def div_footer
      content_tag(:div, class: "Orbital-Dialog-Footer") do
        safe_join([cancel_button, confirm_button(:button)])
      end
    end

    def cancel_button
      if cancel_action?
        cancel_action
      else
        content_tag(:button, @cancel_text, type: "button",
          data: { action: "orbital-modal#close" },
          class: "Orbital-Button", "data-variant": "outline", "data-size": "default")
      end
    end

    def confirm_button(type)
      if confirm_action?
        confirm_action
      else
        opts = { class: "Orbital-Button", "data-variant": "destructive", "data-size": "default", type: type }
        opts[:disabled] = true if @loading
        content_tag(:button, **opts) do
          safe_join([spinner_icon, @confirm_text].compact)
        end
      end
    end

    def spinner_icon
      return nil unless @loading

      content_tag(:span, class: "Orbital-ConfirmationDialog-Spinner") do
        tag.svg(class: "Orbital-Icon animate-spin", width: "16", height: "16", viewBox: "0 0 24 24",
          fill: "none", stroke: "currentColor", "stroke-width": "2",
          "stroke-linecap": "round", "stroke-linejoin": "round") do
          tag.path(d: "M21 12a9 9 0 1 1-6.219-8.56")
        end
      end
    end

    def csrf_hidden_field
      return nil unless defined?(Rails) && helpers.respond_to?(:form_authenticity_token)

      tag.input(type: "hidden", name: "authenticity_token", value: helpers.form_authenticity_token)
    end

    def method_hidden_field
      return nil if @method == :post || @method.nil?

      tag.input(type: "hidden", name: "_method", value: @method)
    end
  end
end
