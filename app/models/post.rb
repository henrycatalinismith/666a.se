class Post < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true
  validates :date, presence: true
  validates :body_en, presence: true
  scope :chronological, -> { order(date: :asc) }
  scope :reverse_chronological, -> { order(date: :desc) }
end
