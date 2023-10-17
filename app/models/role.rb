class Role < ApplicationRecord
  belongs_to :user
  enum name: {
    admin: 0,
  }
end
