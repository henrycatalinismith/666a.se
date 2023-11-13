class Post < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true
  validates :date, presence: true
  validates :body_en, presence: true
end
