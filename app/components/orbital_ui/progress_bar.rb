# frozen_string_literal: true

module OrbitalUi
  class ProgressBar < Component
    attribute :value, :float, default: 0
    attribute :max, :float, default: 100
    attribute :size, :symbol, default: :md, only: %i[xs sm md lg xl]

    orb_template <<-ORB
      <div **html_attributes>
        <div class="Orbital-ProgressBar-Fill" style={fill_style}></div>
      </div>
    ORB

    private

    def fill_style
      percent = @max.to_f.positive? ? (@value.to_f / @max * 100).clamp(0, 100).round(1) : 0
      "width: #{percent}%"
    end

    def default_attributes
      super.merge(
        class: "Orbital-ProgressBar",
        "data-size": @size,
        role: "progressbar",
        "aria-valuenow": @value,
        "aria-valuemin": 0,
        "aria-valuemax": @max
      )
    end
  end
end
