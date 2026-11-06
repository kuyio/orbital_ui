# frozen_string_literal: true

module OrbitalUi
  class Badge < Component
    include OrbitalUi::Concerns::IconProp

    attribute :variant, :symbol, default: :default, only: [:default, :secondary, :destructive, :ghost, :outline]
    attribute :dot, :symbol, default: nil, only: [:default, :success, :warning, :danger, :info, :subdued]
    attribute :icon, :any, default: nil

    orb_template <<~ORB
      <span **html_attributes>
        {{render_icon}}
        {{content}}
        <span class="Orbital-Badge-Dot" data-tone={@dot} :if={@dot}/>
      </span>
    ORB

    private

    def default_attributes
      super.merge(
        class: "Orbital-Badge",
        "data-variant": @variant
      )
    end
  end
end
