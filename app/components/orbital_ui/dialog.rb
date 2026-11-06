# frozen_string_literal: true

module OrbitalUi
  class Dialog < Component
    attribute :open, :boolean, default: false
    attribute :dismissible, :boolean, default: true
    attribute :size, :symbol, default: :default, only: [:sm, :default, :lg, :xl, :full]

    renders_one :header
    renders_one :body
    renders_one :footer

    orb_template <<-ORB
      <Modal open={@open} dismissible={@dismissible} size={@size} **html_attributes>
        <div class="Orbital-Dialog">
          <button :if={@dismissible}
            type="button"
            data-action="orbital-modal#close"
            class="Orbital-Dialog-Close"
            aria-label="Close">
            <svg class="Orbital-Icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>

          <div class="Orbital-Dialog-Header" :if={header}>
            {{header}}
          </div>

          <div class="Orbital-Dialog-Body" :if={body}>
            {{body}}
          </div>

          <div class="Orbital-Dialog-Body" :if={!body}>
            {{content}}
          </div>

          <div class="Orbital-Dialog-Footer" :if={footer}>
            {{footer}}
          </div>
        </div>
      </Modal>
    ORB
  end
end
