class User::Role < ApplicationRecord
  has_many :authorizations, class_name: "User::Authorization", foreign_key: "role_id"
  has_many :accounts, through: :authorizations, class_name: "User::Account", foreign_key: "account_id"

  rails_admin do
    list do
      field :name
      field :description
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end
end
