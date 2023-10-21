class Policy < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true
  validates :icon, format: { with: /\Afa-/ }
  validates :body, presence: true
end
