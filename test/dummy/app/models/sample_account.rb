# frozen_string_literal: true

# A small model for the Form docs page. The docs app has no database.
class SampleAccount
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :plan, :string, default: "pro"
  attribute :newsletter, :boolean, default: true

  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be an email address" }

  def persisted? = false
end
