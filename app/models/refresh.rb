class Refresh < ApplicationRecord
  belongs_to :subscription
  has_many :notifications
  has_many :searches

  enum status: {
    pending: 0,
    active: 1,
    success: 2,
    error: 3,
    aborted: 4,
  }
end
