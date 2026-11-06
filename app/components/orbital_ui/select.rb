# frozen_string_literal: true

module OrbitalUi
  class Select < Component
    attribute :options, :array, default: []
    attribute :selected, :string, default: nil
    attribute :value, :string, default: nil
    attribute :placeholder, :string, default: "Select..."
    attribute :name, :string, default: nil
    attribute :id, :string, default: nil
    attribute :label, :string, default: nil
    attribute :labelHidden, :boolean, default: false
    attribute :help, :string, default: nil
    attribute :error, :string, default: nil
    attribute :disabled, :boolean, default: false
    attribute :required, :boolean, default: false
    attribute :position, :symbol, default: :s
    attribute :fullwidth, :boolean, default: false

    def initialize(kwargs = {})
      super
      @selected ||= @value
    end

    orb_template <<-ORB
      <div class="Orbital-Field" data-fullwidth={@fullwidth || nil}>
        <label for={input_id} class="Orbital-Field-Label" data-hidden={@labelHidden || nil} :if={render_label?}>
          <Text size="sm" weight=medium>{{label_text}}</Text>
        </label>

        <div **html_attributes>
          <input
            type="hidden"
            id={input_id}
            name={@name}
            value={@selected}
            data-orbital-select-target="input"
            class="Orbital-Select-Input"
          />

          <Dropdown
            position={@position}
            fullwidth
            id={dropdown_id}>

            <Dropdown:Trigger>
              <Button
                variant="outline"
                disabled={@disabled}
                class={button_classes}>
                <span
                  data-orbital-select-target="label"
                  class={label_classes}>
                  {{display_label}}
                </span>
                <Icon name="chevron-down" size="sm"/>
              </Button>
            </Dropdown:Trigger>

            <Menu>
              {#for option in @options}
                <Menu::Item
                  data-value={option[:value]}
                  data-label={option[:label]}
                  disabled={option[:disabled] || false}
                  selected={option[:value].to_s == @selected}
                  data-action="click->orbital-select#handleItemClick">
                  {{option[:label]}}
                </Menu::Item>
              {/for}
            </Menu>
          </Dropdown>
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

    def default_attributes
      super.merge(
        class: class_names(
          "Orbital-Select",
          "Orbital-Select--fullwidth": @fullwidth
        ),
        data: {
          controller: "orbital-select",
          "orbital-select-selected-value": @selected,
          error: error? || nil
        }
      )
    end

    def input_id
      @id ||= "select-#{SecureRandom.hex(4)}"
    end

    def dropdown_id
      "#{input_id}-dropdown"
    end

    def label_text
      @label || @name.to_s.humanize
    end

    def render_label?
      (@label.present? || @name.present?) && !@labelHidden
    end

    def selected_option
      @options.find { |opt| opt[:value].to_s == @selected }
    end

    def display_label
      selected_option ? selected_option[:label] : @placeholder
    end

    def label_classes
      class_names(
        selected_option ? "Orbital-Select-Label" : "Orbital-Select-Placeholder"
      )
    end

    def button_classes
      class_names(
        "Orbital-Select-Trigger",
        "border-red-500": error?
      )
    end

    def help?
      @help.present?
    end

    def error?
      @error.present?
    end
  end
end
