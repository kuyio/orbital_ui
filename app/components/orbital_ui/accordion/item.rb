# frozen_string_literal: true

class OrbitalUi::Accordion::Item < OrbitalUi::Component
  renders_one :trigger

  attribute :value, :string, required: true
  attribute :expanded, :boolean, default: false

  orb_template <<-ORB
    <div **html_attributes>
      <Heading as="button" size="sm" class="flex justify-between cursor-pointer w-full py-4 gap-2" data-accordion-trigger>
        <span class="flex items-center gap-2">{{trigger}}</span>
        <Icon name="chevron-down" size="small" class="shrink-0" data-accordion-chevron/>
      </Heading>
      <div class="Orbital-Accordion-Item-Content" data-state={state}>
        <div class="Orbital-Accordion-Item-Inner">
          {{content}}
        </div>
      </div>
    </div>
  ORB

  private

  def state
    @expanded ? "open" : "closed"
  end

  def default_attributes
    super.merge(class: "Orbital-Accordion-Item")
  end
end
