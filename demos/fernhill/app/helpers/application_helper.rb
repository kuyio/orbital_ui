# frozen_string_literal: true

module ApplicationHelper
  def account_options
    Ledger::ACCOUNT_NAMES.map { |name| { label: name, value: name } }
  end

  def signed_currency(amount)
    "#{'+' if amount.positive?}#{number_to_currency(amount)}"
  end

  def status_variant(status)
    { completed: :secondary, pending: :outline, failed: :destructive }.fetch(status)
  end

  def bar_height(value, ceiling)
    "height: #{(value / ceiling * 100).round}%"
  end
end
