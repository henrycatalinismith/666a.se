class Legal::Element < ApplicationRecord
  belongs_to :revision
  has_many :translations
  #validates :element_code, presence: true
  validates :element_index, presence: true
  validates :element_text, presence: true
  validates :element_type, presence: true
end