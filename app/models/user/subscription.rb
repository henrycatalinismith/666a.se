class User::Subscription < ApplicationRecord
  belongs_to :account
  has_many :notifications, dependent: :destroy

  enum :subscription_status, {
    inactive_subscription: 0,
    active_subscription: 1,
  }

  enum :subscription_type, {
    company_subscription: 0,
    workplace_subscription: 1,
  }

  normalizes :company_code, with: -> company_code { company_code.strip }
  validates :company_code, format: { with: /\A\d{6}-\d{4}\z/, allow_blank: true }

  normalizes :workplace_code, with: -> workplace_code { workplace_code.strip }
  validates :workplace_code, format: { with: /\A\d{8}\z/, allow_blank: true }

  def has_notification?(document_id)
    notifications.where(document_id:).count > 0
  end
end
