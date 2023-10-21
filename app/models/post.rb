class Post < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true
  validates :date, presence: true
  validates :body, presence: true
end
