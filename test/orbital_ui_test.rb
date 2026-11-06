# frozen_string_literal: true

require "test_helper"

class OrbitalTest < ActiveSupport::TestCase
  def test_has_a_version_number
    assert_not_nil OrbitalUi::VERSION
  end

  def test_provides_a_component_base_class
    assert_operator OrbitalUi::Component, :<, ViewComponent::Base
  end
end
