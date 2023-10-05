class Refresh < ApplicationRecord
  belongs_to :subscription
  belongs_to :search
  has_many :notifications, dependent: :destroy

  enum :status, {
    pending: 0,
    active: 1,
    success: 2,
    error: 3,
    aborted: 4,
  }
end
