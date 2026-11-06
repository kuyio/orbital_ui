# frozen_string_literal: true

require "view_component"
require "orb_template"
require_relative "orbital_ui/version"
require_relative "orbital_ui/engine"
require_relative "orbital_ui/icons"
require_relative "orbital_ui/attribute_utils"
require_relative "orbital_ui/components/attributes"
require_relative "orbital_ui/components/styles"
require_relative "orbital_ui/type/any"
require_relative "orbital_ui/type/array"
require_relative "orbital_ui/type/breakpoints"
require_relative "orbital_ui/type/symbol"

module OrbitalUi
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :dialog_portal_id

    def initialize
      @dialog_portal_id = "dialogs"
    end

    # Backward compatibility for modal_portal_id (deprecated)
    def modal_portal_id
      warn "[DEPRECATION] `modal_portal_id` is deprecated. Please use `dialog_portal_id` instead."
      @dialog_portal_id
    end

    def modal_portal_id=(value)
      warn "[DEPRECATION] `modal_portal_id=` is deprecated. Please use `dialog_portal_id=` instead."
      @dialog_portal_id = value
    end
  end

  # Default configuration
  self.configuration = Configuration.new
end
