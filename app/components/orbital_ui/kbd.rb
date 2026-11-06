# frozen_string_literal: true

class OrbitalUi::Kbd < OrbitalUi::Component
  orb_template <<-ORB
    <kbd **html_attributes>
      {{content}}
    </kbd>
  ORB

  private

  def default_attributes
    super.merge(class: 'Orbital-Kbd')
  end
end
