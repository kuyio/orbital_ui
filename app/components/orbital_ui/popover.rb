# frozen_string_literal: true

module OrbitalUi
  class Popover < Component
    attribute :id, :string, default: -> { "popover-#{SecureRandom.hex(4)}" }
    attribute :on, :symbol, default: :click, only: [:click, :hover]
    attribute :position, :symbol, default: :auto, only: [:auto, :n, :ne, :e, :se, :s, :sw, :w, :nw]

    renders_one :trigger

    orb_template <<-ORB
      <div **html_attributes>
        {#if trigger}
          <div
            data-orbital-popover-target="trigger">
            {{trigger}}
          </div>
        {/if}
        {#if content}
          <div
            popover
            id={@id}
            data-orbital-popover-target="content"
            class={content_class}
            data-position={@position}>
            {{content}}
          </div>
        {/if}
      </div>
    ORB

    private

    def content_class
      "Orbital-Popover"
    end

    def default_attributes
      super.merge(
        class: "Orbital-Popover-Container",
        data: {
          controller: "orbital-popover",
          "orbital-popover-trigger-value": @on,
          "orbital-popover-position-value": @position,
          state: "closed"
        }
      )
    end
  end
end
