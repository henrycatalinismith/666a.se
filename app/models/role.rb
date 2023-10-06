class Role < ApplicationRecord
  belongs_to :user
  enum status: {
    admin: 0,
  }
end
