# frozen_string_literal: true

class Demo::ComponentCard < OrbitalUi::Component
  attribute :name, :string, required: true

  def call
    content_tag(:a, href: "/components/#{@name}", **html_attributes) do
      safe_join([
        content_tag(:div, content, class: "demo-component-card-preview", inert: ""),
        content_tag(:div, label, class: "demo-component-card-label")
      ])
    end
  end

  private

  def label
    @name.titleize
  end

  def default_attributes
    super.merge(class: "demo-component-card group")
  end
end
