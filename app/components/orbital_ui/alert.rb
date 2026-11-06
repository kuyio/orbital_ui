# frozen_string_literal: true

module OrbitalUi
  class Alert < Component
    attribute :open, :boolean, default: false
    attribute :dismissible, :boolean, default: true
    attribute :size, :symbol, default: :default, only: [:sm, :default, :lg, :xl, :full]
    attribute :title, :string, default: nil
    attribute :description, :string, default: nil
    attribute :variant, :symbol, default: :default, only: [:default, :success, :warning, :danger, :info]
    attribute :button_text, :string, default: "OK"

    orb_template <<-ORB
      <Modal open={@open} dismissible={@dismissible} size={@size} **html_attributes>
        <div class="Orbital-Dialog" data-variant={@variant}>
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

          <div class="Orbital-Dialog-Header">
            <div class="Orbital-Alert-Content">
              {#if variant_icon}
                <div class="Orbital-Alert-Icon" data-variant={@variant}>
                  {{variant_icon}}
                </div>
              {/if}
              <div class="Orbital-Alert-Text">
                {#if @title}
                  <h2 class="Orbital-Dialog-Title">{{@title}}</h2>
                {/if}
                {#if @description}
                  <p class="Orbital-Dialog-Description">{{@description}}</p>
                {/if}
              </div>
            </div>
          </div>

          {#if content}
            <div class="Orbital-Dialog-Body">
              {{content}}
            </div>
          {/if}

          <div class="Orbital-Dialog-Footer">
            <button
              data-action="orbital-modal#close"
              class="Orbital-Button"
              data-variant="default"
              data-size="default"
              type="button">
              {{@button_text}}
            </button>
          </div>
        </div>
      </Modal>
    ORB

    private

    def variant_icon
      icon_name = case @variant
                  when :success then "circle-check"
                  when :warning then "triangle-alert"
                  when :danger then "circle-alert"
                  when :info then "info"
                  end

      return nil unless icon_name

      render OrbitalUi::Icon.new(name: icon_name, size: :lg)
    end
  end
end
