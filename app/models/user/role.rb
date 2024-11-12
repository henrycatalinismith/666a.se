class User::Role < ApplicationRecord
  has_many :authorizations, class_name: "User::Authorization", foreign_key: "role_id"
  has_many :accounts, through: :authorizations, class_name: "User::Account", foreign_key: "account_id"
end
