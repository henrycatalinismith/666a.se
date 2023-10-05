class Search < ApplicationRecord
  has_many :refreshes
  has_many :results

  enum status: {
    pending: 0,
    active: 1,
    success: 2,
    error: 3,
    aborted: 4,
  }
end
