# frozen_string_literal: true

# A transfer between two of the user's accounts. It has no database, like the rest of this demo.
class Transfer
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :from, :string, default: -> { Ledger::ACCOUNT_NAMES[0] }
  attribute :to, :string, default: -> { Ledger::ACCOUNT_NAMES[1] }
  attribute :amount, :decimal

  validates :from, :to, inclusion: { in: Ledger::ACCOUNT_NAMES, message: "must be one of your accounts" }
  validates :amount, numericality: { greater_than: 0, message: "must be more than $0" }
  validate :accounts_differ

  def persisted? = false

  def to_session = { "from" => from, "to" => to, "amount" => amount.to_f }

  private

  def accounts_differ
    errors.add(:to, "must be a different account") if from == to
  end
end
