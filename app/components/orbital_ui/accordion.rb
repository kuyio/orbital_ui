# frozen_string_literal: true

class OrbitalUi::Accordion < OrbitalUi::Component
  renders_many :items, OrbitalUi::Accordion::Item

  orb_template <<-ORB
    <div **html_attributes>
      {#for item in items}
        {{item}}
      {/for}
    </div>
  ORB

  private

  def default_attributes
    super.merge(
      class: "Orbital-Accordion",
      role: "region",
      data: { controller: "o-accordion" }
    )
  end
end
