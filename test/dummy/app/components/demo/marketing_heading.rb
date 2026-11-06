# frozen_string_literal: true

class Demo::MarketingHeading < OrbitalUi::Component
  orb_template <<-ORB
    <h1 **html_attributes>
      {{content}}
    </h1>
  ORB

  private

  def default_attributes
    super.merge(class: class_names(
      "text-primary",
      "text-4xl",
      "leading-tighter",
      "font-bold",
      "text-balance",
      "lg:leading-[1.1] lg:font-bold",
      "lg:tracking-tight",
      "xl:text-5xl"
    ))
  end
end
