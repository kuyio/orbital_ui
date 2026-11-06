# frozen_string_literal: true

class OrbitalUi::Spinner < OrbitalUi::Component
  attribute :size, :string, default: "md" # sm, md, lg
  attribute :tone, :string, default: "primary" # primary, secondary, accent
  attribute :kind, :string, only: %w[notch dots], default: "notch"

  orb_template <<-ORB
    <div class="Orbital-Spinner" data-kind={@kind} data-size={@size} role="status" aria-live="polite" aria-busy="true">
      <span class="sr-only">Loading...</span>
      <Icon name="loader-circle" size={@size}/>
    </div>
  ORB
end
