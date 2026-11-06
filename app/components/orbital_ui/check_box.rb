# frozen_string_literal: true

class OrbitalUi::CheckBox < OrbitalUi::Component
  attribute :name, :string, default: nil
  attribute :value, :string, default: "1"
  attribute :label, :string, default: nil
  attribute :help, :string, default: nil
  attribute :error, :string, default: nil
  attribute :checked, :boolean, default: false
  attribute :disabled, :boolean, default: false
  attribute :id, :string, default: nil

  orb_template <<-ORB
    <div class="Orbital-CheckBox">
      <label for={input_id} class="Orbital-CheckBox-Label">
        <div class="Orbital-CheckBox-Control">
          <input **html_attributes />
          <span class="Orbital-CheckBox-Indicator"/>
          <Icon name="check" size="sm" class="Orbital-CheckBox-Icon" />
        </div>
        <Text>{{ label_text }}</Text>
      </label>

      {#if @error.present?}
        <Text tone="danger" size="sm">{{ @error }}</Text>
      {/if}

      {#if @help.present? && !@error.present?}
        <Text tone="subdued" size="sm">{{ @help }}</Text>
      {/if}
    </div>
  ORB

  private

  def default_attributes
    super.merge(
      name: @name,
      value: @value,
      id: input_id,
      class: "Orbital-CheckBox-Input",
      type: "checkbox",
      checked: @checked,
      disabled: @disabled
    )
  end

  def label_text
    @label || @name.to_s.humanize
  end

  def input_id
    @id ||= SecureRandom.hex(4)
  end

  def help?
    @help.present?
  end
end
