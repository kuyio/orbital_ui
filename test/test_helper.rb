# frozen_string_literal: true

require "bundler/setup"

# Fail on Ruby warnings from this gem's own code. A warning here has already hidden a real bug.
GEM_ROOT = File.expand_path("..", __dir__)

module Warning
  def self.warn(message, **)
    raise message if message.include?(GEM_ROOT)

    super
  end
end

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "view_component"
require "orbital_ui"

# The README requires this of every app.
ORB.namespaces += %w[OrbitalUi]

class TestApp < Rails::Application
  config.load_defaults Rails::VERSION::STRING.to_f
  config.eager_load = false
  config.secret_key_base = "test"
end

TestApp.initialize!

require "active_support/test_case"
require "minitest/autorun"
