class User::Role < ApplicationRecord
  belongs_to :account
  enum name: {
    admin: 0,
  }
end
