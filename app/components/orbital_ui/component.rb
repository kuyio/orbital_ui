# frozen_string_literal: true

module OrbitalUi
  class Component < ViewComponent::Base
    # This module imports the attribute DSL for defining attributes on a component
    # as well as the html_attributes method for generating HTML attributes
    include OrbitalUi::Components::Attributes

    # This module provides a method for joining style names together
    include OrbitalUi::Components::Styles
  end
end
