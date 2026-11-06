# frozen_string_literal: true

require "digest/md5"

class OrbitalUi::Avatar < OrbitalUi::Component
  include OrbitalUi::Concerns::IconProp

  attribute :name, :string, default: nil
  attribute :email, :string, default: nil
  attribute :initials, :string, default: nil
  attribute :size, :symbol, default: :md, only: [:xs, :sm, :md, :lg, :xl]
  attribute :icon, :any, default: "user"
  attribute :round, :boolean, default: true
  attribute :square, :boolean, default: false

  def call
    content_tag(:div, **html_attributes) do
      if gravatar_url
        tag.img(
          src: gravatar_url,
          alt: @name || "",
          class: "Orbital-Avatar-Image",
          loading: "lazy",
          "data-orbital-avatar-target": "image",
          "data-action": "error->orbital-avatar#imageError"
        ) + fallback_element(hidden: true)
      else
        fallback_element
      end
    end
  end

  private

  def fallback_element(hidden: false)
    opts = { "data-orbital-avatar-target": "fallback" }
    opts[:style] = "display:none;" if hidden
    if @initials.present?
      content_tag(:span, @initials.upcase[0, 2], class: "Orbital-Avatar-Initials", **opts)
    else
      content_tag(:span, class: "Orbital-Avatar-Icon", **opts) do
        render_icon(@icon, size: icon_size)
      end
    end
  end

  def icon_size
    case @size
    when :xs, :sm then :xs
    when :md then :sm
    when :lg, :xl then :md
    end
  end

  def gravatar_url
    return nil unless @email.present?

    hash = Digest::MD5.hexdigest(@email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?d=404&s=#{pixel_size}"
  end

  def pixel_size
    case @size
    when :xs then 24
    when :sm then 32
    when :md then 40
    when :lg then 48
    when :xl then 64
    end
  end

  def shape
    @square ? "square" : "round"
  end

  def default_attributes
    attrs = super.merge(
      class: "Orbital-Avatar",
      "data-size": @size,
      "data-shape": shape,
      "data-controller": gravatar_url ? "orbital-avatar" : nil
    )
    attrs[:title] = @name if @name.present?
    attrs["aria-label"] = @name if @name.present?
    attrs
  end
end
