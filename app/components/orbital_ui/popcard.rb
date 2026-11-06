# frozen_string_literal: true

module OrbitalUi
  class Popcard < Popover
    attribute :on, :symbol, default: :hover, only: [:click, :hover]
    attribute :position, :symbol, default: :n, only: [:auto, :n, :ne, :e, :se, :s, :sw, :w, :nw]

    private

    def default_attributes
      super.merge(class: "Orbital-Popcard-Container")
    end

    def content_class
      "Orbital-Popcard"
    end
  end
end
