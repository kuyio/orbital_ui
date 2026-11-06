# frozen_string_literal: true

class OrbitalUi::Expander < OrbitalUi::Component
  attribute :vertical, type: :boolean, default: false

  orb_template <<-ORB
    <div **html_attributes></div>
  ORB

  private

  def default_attributes
    super.merge(
      class: class_names(
        "Orbital-Expander",
        "Orbital-Expander--vertical": @vertical
      )
    )
  end
end
