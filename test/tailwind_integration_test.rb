# frozen_string_literal: true

require "test_helper"

class TailwindIntegrationTest < ActiveSupport::TestCase
  ROOT = OrbitalUi::Engine.root

  test "the theme makes dark utilities follow the dark class" do
    assert_includes ROOT.join("app/assets/stylesheets/orbital_ui/theme.css").read,
      "@custom-variant dark (&:where(.dark, .dark *));"
  end

  test "every component stylesheet is in a cascade layer so app utilities can override it" do
    unlayered = ROOT.glob("frontend/stylesheets/components/*.css").reject { |file| file.read.match?(/^@layer /) }

    assert_empty unlayered.map { |file| file.basename.to_s }
  end
end
