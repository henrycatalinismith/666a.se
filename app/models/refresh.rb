class Refresh < ApplicationRecord
  belongs_to :subscription

  enum status: {
    pending: 0,
    active: 1,
    success: 2,
    aborted: 3,
  }
end
