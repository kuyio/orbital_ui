# frozen_string_literal: true

class OrbitalUi::Prose < OrbitalUi::Component
  def call
    content_tag :div, **html_attributes do
      content
    end
  end

  private

  def default_attributes
    super.merge(class: "Orbital-Prose")
  end
end
