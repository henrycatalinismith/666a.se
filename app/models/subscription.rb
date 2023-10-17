class Subscription < ApplicationRecord
  belongs_to :user
  has_many :notifications

  enum :status, {
    inactive: 0,
    active: 1,
  }

  normalizes :company_code, with: -> company_code { company_code.strip }
  validates :company_code, format: { with: /\A\d{6}-\d{4}\z/ }

  def has_notification?(document_id)
    notifications.where(document_id:).count > 0
  end
end
