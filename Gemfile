# frozen_string_literal: true

source "https://rubygems.org"

# Runtime dependencies are in orbital_ui.gemspec.
gemspec

group :development, :test do
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "irb"
  gem "kuyio-rubocop", github: "kuyio/kuyio-rubocop"
  gem "minitest"
  gem "rake"
end

# Dummy app (test/dummy): always on the latest Rails.
gem "bootsnap", require: false
gem "orb_template"
gem "propshaft"
gem "puma"
gem "rails", "~> 8.1.4", ">= 8.1.4.1"
gem "thruster", require: false
gem "turbo-rails"
