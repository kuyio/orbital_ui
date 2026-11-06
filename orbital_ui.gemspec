# frozen_string_literal: true

require_relative "lib/orbital_ui/version"

Gem::Specification.new do |spec|
  spec.name = "orbital_ui"
  spec.version = OrbitalUi::VERSION
  spec.authors = ["KUY.io Inc."]
  spec.email = ["dev@kuy.io"]

  spec.summary = "A design system and component library for Ruby on Rails."
  spec.description = "Orbital is a themable set of ViewComponents built with the ORB template language " \
                     "and Tailwind CSS, with bundled styles, Stimulus controllers and icons."
  spec.homepage = "https://github.com/kuyio/orbital_ui"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/main"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["{app,lib}/**/*", "LICENSE", "README.md"]

  spec.add_dependency "orb_template", "~> 0.3.0"
  spec.add_dependency "rails", ">= 7.1"
  spec.add_dependency "view_component", ">= 4.0"
end
