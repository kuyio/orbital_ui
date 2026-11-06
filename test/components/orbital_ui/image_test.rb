# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class ImageTest < ActiveSupport::TestCase
    def render(component)
      ActionController::Base.new.view_context.render(component).to_s
    end

    def test_src_renders_the_url_unchanged
      html = render(Image.new(src: "https://cdn.example.com/photo.jpg", alt: "Photo"))

      assert_includes html, 'src="https://cdn.example.com/photo.jpg"'
      assert_includes html, 'alt="Photo"'
      assert_includes html, 'class="Orbital-Image"'
    end

    def test_asset_resolves_through_asset_path
      assert_includes render(Image.new(asset: "logo.svg")), 'src="/logo.svg"'
    end

    def test_passing_both_raises
      error = assert_raises(ArgumentError) { Image.new(asset: "logo.svg", src: "/photo.jpg") }

      assert_equal "Image requires exactly one of :asset or :src", error.message
    end

    def test_passing_neither_raises
      assert_raises(ArgumentError) { Image.new(alt: "Photo") }
    end

    def test_a_blank_value_counts_as_not_passed
      assert_raises(ArgumentError) { Image.new(src: "") }
      assert_includes render(Image.new(src: "", asset: "logo.svg")), "logo.svg"
    end
  end
end
