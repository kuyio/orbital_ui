# frozen_string_literal: true

require "test_helper"

module OrbitalUi
  class CardTest < ActiveSupport::TestCase
    def render(component)
      ActionController::Base.new.view_context.render(component) { "hello" }.to_s
    end

    def test_content_has_no_data_attributes_by_default
      html = render(Card.new)

      assert_includes html, '<div class="Orbital-Card-Content">hello</div>'
      assert_not_includes html, "data-gap"
      assert_not_includes html, "data-padding"
    end

    def test_gap_and_padding_apply_to_the_content_area
      html = render(Card.new(gap: "4", padding: "2"))

      assert_includes html, '<div class="Orbital-Card-Content" data-gap="4" data-padding="2">hello</div>'
    end

    def test_zero_padding_is_kept
      assert_includes render(Card.new(padding: "0")), 'data-padding="0"'
    end

    def test_props_do_not_reach_the_card_root
      assert_match(/\A\s*<div class="Orbital-Card">/, render(Card.new(gap: "4", padding: "2")))
    end
  end
end
