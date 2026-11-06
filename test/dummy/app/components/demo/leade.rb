# frozen_string_literal: true

class Demo::Leade < OrbitalUi::Component
  orb_template <<-ORB
    <p **html_attributes>
      {{content}}
    </p>
  ORB

  private

  def default_attributes
    super.merge(class: class_names(
      "text-foreground",
      "text-body-xl",
      "text-balance",
      "sm:text-body-xl"
    ))
  end
end
