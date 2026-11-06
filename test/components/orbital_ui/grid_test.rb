# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class GridTest < ActiveSupport::TestCase
    def attrs(**kwargs)
      Grid.new(**kwargs).send(:default_attributes)
    end

    def test_is_a_component_subclass
      assert_operator Grid, :<, Component
    end

    def test_includes_the_orbital_grid_class
      assert_equal "Orbital-Grid", attrs[:class]
    end

    def test_defaults_columns_to_1
      assert_equal "1", attrs[:"data-columns"]
    end

    def test_defaults_gap_to_4
      assert_equal "4", attrs[:"data-gap"]
    end

    def test_sets_data_columns_from_the_columns_attribute
      assert_equal "3", attrs(columns: "3")[:"data-columns"]
    end

    def test_sets_data_gap_from_the_gap_attribute
      assert_equal "8", attrs(gap: "8")[:"data-gap"]
    end
  end
end
