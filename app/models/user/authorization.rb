class User::Authorization < ApplicationRecord
  belongs_to :account, class_name: "User::Account", foreign_key: "account_id"
  belongs_to :role, class_name: "User::Role", foreign_key: "role_id"

  rails_admin do
    list do
      field :account
      field :role
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end
end
