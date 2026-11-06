# frozen_string_literal: true

module OrbitalUi
  class Modal < Component
    attribute :open, :boolean, default: false
    attribute :dismissible, :boolean, default: true
    attribute :size, :symbol, default: :default, only: [:sm, :default, :lg, :xl, :full]

    orb_template <<~ORB
      <div **html_attributes>
        <div class="Orbital-Modal-Backdrop" data-action="click->orbital-modal#backdropClick"></div>
        <div class="Orbital-Modal-Container">
          <div class="Orbital-Modal-Panel" data-size={@size} data-orbital-modal-target="panel">
            {{content}}
          </div>
        </div>
      </div>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-Modal",
        role: "dialog",
        "aria-modal": "true",
        data: {
          controller: "orbital-modal",
          "orbital-modal-open-value": @open.to_s,
          "orbital-modal-dismissible-value": @dismissible.to_s,
          state: @open ? "open" : "closed"
        }
      )
    end
  end
end
