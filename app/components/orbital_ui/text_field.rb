# frozen_string_literal: true

module OrbitalUi
  class TextField < Component
    attribute :type, :string, default: "text"
    attribute :disabled, :boolean, default: false
    attribute :readonly, :boolean, default: false
    attribute :name, :string, default: nil
    attribute :value, :string, default: nil
    attribute :label, :string, default: nil
    attribute :labelHidden, :boolean, default: false
    attribute :iconLeft, :any, default: nil
    attribute :iconRight, :any, default: nil
    attribute :prefix, :string, default: nil
    attribute :suffix, :string, default: nil
    attribute :multiline, :integer, default: nil
    attribute :required, :boolean, default: false
    attribute :placeholder, :string, default: nil
    attribute :help, :string, default: nil
    attribute :error, :string, default: nil
    attribute :autofocus, :boolean, default: false
    attribute :fullwidth, :boolean, default: false
    attribute :rightAligned, :boolean, default: false
    attribute :resizable, :boolean, default: false

    orb_template <<-ORB
    <div class="Orbital-Field" data-fullwidth={@fullwidth || nil}>
      <label for={input_id} class="Orbital-Field-Label" data-hidden={@labelHidden || nil} :if={render_label?}>
        <Text size="sm" weight=medium>{{label_text}}</Text>
      </label>
      <div class="Orbital-Input relative flex items-center">
        <div class="Orbital-Input-Icon" data-position="left" :if={@iconLeft || @prefix}>
          <Icon name={@iconLeft} size=md class="p-1 text-gray-300" :if={@iconLeft} />
          <Text tone="subdued" :if={@prefix}>{{ @prefix }}</Text>
        </div>
        {{ render_input }}
        <div class="Orbital-Input-Icon" data-position="right" :if={@iconRight || @suffix}>
          <Icon name={@iconRight} size=md class="p-1 text-gray-300" :if={@iconRight} />
          <Text tone="subdued" :if={@suffix}>{{ @suffix }}</Text>
        </div>
      </div>
      <div class="Orbital-Field-Help leading-none" :if={help? || error?}>
        {% if error? %}
          <Text size="sm" weight=medium tone="danger" class="leading-none!">{{ @error }}</Text>
        {% else %}
          <Text size="sm" tone="subdued" class="leading-none!">{{ @help }}</Text>
        {% end %}
      </div>
    </div>
    ORB

    private

    def label_classes
      "Orbital-Field-Label"
    end

    def label_text
      @label || @name.to_s.humanize
    end

    def render_label?
      (@label.present? || @name.present?) && !@labelHidden
    end

    def help?
      @help.present?
    end

    def error?
      @error.present?
    end

    def render_input
      common_opts = {
        id: input_id,
        name: @name,
        value: @value,
        disabled: @disabled,
        readonly: @readonly,
        required: @required,
        placeholder: @placeholder,
        autofocus: @autofocus,
        autocomplete: "off",
        class: input_classes,
        "data-error": error? || nil,
        "data-align": @rightAligned ? "right" : nil
      }

      if @multiline
        tag.textarea(**common_opts, rows: @multiline)
      else
        tag.input(type: @type, **common_opts)
      end
    end

    def input_padding_left
      if @iconLeft && @prefix
        "pl-11"
      elsif @iconLeft || @prefix
        "pl-8"
      else
        "pl-2"
      end
    end

    def input_padding_right
      if @iconRight && @suffix
        "pr-10"
      elsif @iconRight || @suffix
        "pr-8"
      else
        "pr-2"
      end
    end

    def input_classes
      padding_left = input_padding_left
      padding_right = input_padding_right

      class_names(
        padding_left,
        padding_right,
        "noresize" => !@resizable
      )
    end

    def input_id
      @id ||= "input-#{SecureRandom.hex(4)}"
    end
  end
end
