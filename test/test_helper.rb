# frozen_string_literal: true

require "bundler/setup"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "view_component"
require "orbital_ui"

class TestApp < Rails::Application
  config.eager_load = false
  config.secret_key_base = "test"
end

TestApp.initialize!

require "active_support/test_case"
require "minitest/autorun"
