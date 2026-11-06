# frozen_string_literal: true

class OrbitalUi::NavigationMenu < OrbitalUi::Component
  renders_one :brand
  renders_one :mobile

  def call
    popover_id = "nav-mobile-#{SecureRandom.hex(4)}"
    has_mobile = mobile?

    content_tag :nav, **html_attributes do
      safe_join([
        brand,
        has_mobile ? mobile_trigger(popover_id) : nil,
        nav_content,
        has_mobile ? mobile_popover(popover_id) : nil
      ].compact)
    end
  end

  private

  def mobile_trigger(popover_id)
    content_tag(:button,
      class: "Orbital-NavigationMenu-Toggle",
      popovertarget: popover_id,
      popovertargetaction: "toggle",
      style: "anchor-name: --nav-toggle-#{popover_id}",
      "aria-label": "Menu") do
      render OrbitalUi::Icon.new(name: "menu", size: :md)
    end
  end

  def nav_content
    content_tag(:div, class: "Orbital-NavigationMenu-Content") do
      content
    end
  end

  def mobile_popover(popover_id)
    tag.div(mobile,
      id: popover_id,
      popover: "auto",
      class: "Orbital-NavigationMenu-Mobile",
      style: "position-anchor: --nav-toggle-#{popover_id}")
  end

  def default_attributes
    super.merge(class: "Orbital-NavigationMenu")
  end
end
