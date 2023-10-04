class Subscription < ApplicationRecord
  belongs_to :user
  has_many :notifications, through: :refreshes
  has_many :refreshes

  enum :status, {
    inactive: 0,
    active: 1,
  }
end
