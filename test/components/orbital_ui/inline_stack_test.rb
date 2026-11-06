# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class InlineStackTest < ActiveSupport::TestCase
    def attrs(**kwargs)
      InlineStack.new(**kwargs).send(:default_attributes)
    end

    def test_is_a_component_subclass
      assert_operator InlineStack, :<, Component
    end

    def test_includes_the_orbital_inline_stack_class
      assert_equal "Orbital-InlineStack", attrs[:class]
    end

    def test_defaults_gap_to_4
      assert_equal "4", attrs[:"data-gap"]
    end

    def test_defaults_align_to_stretch
      assert_equal :stretch, attrs[:"data-align"]
    end

    def test_defaults_justify_to_start
      assert_equal :start, attrs[:"data-justify"]
    end

    def test_sets_data_gap_from_the_gap_attribute
      assert_equal "8", attrs(gap: "8")[:"data-gap"]
    end

    def test_sets_data_align_from_the_align_attribute
      assert_equal :center, attrs(align: :center)[:"data-align"]
    end

    def test_sets_data_justify_from_the_justify_attribute
      assert_equal :between, attrs(justify: :between)[:"data-justify"]
    end

    def test_sets_data_padding_when_padding_is_provided
      assert_equal "4", attrs(padding: "4")[:"data-padding"]
    end

    def test_omits_data_wrap_when_wrap_is_nil
      assert_not_includes attrs.keys, :"data-wrap"
    end

    def test_sets_data_wrap_to_true_for_bare_wrap
      assert_equal true, attrs(wrap: "true")[:"data-wrap"]
    end

    def test_sets_data_wrap_to_reverse
      assert_equal "reverse", attrs(wrap: "reverse")[:"data-wrap"]
    end
  end
end
