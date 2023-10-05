class Subscription < ApplicationRecord
  belongs_to :user
  has_many :notifications, through: :refreshes
  has_many :refreshes, dependent: :destroy

  enum :status, {
    inactive: 0,
    active: 1,
  }

  normalizes :company_code, with: -> company_code { company_code.strip }
  validates :company_code, format: { with: /\A\d{6}-\d{4}\z/ }
end
