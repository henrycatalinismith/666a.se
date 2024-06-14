class Glossary::Translation < ApplicationRecord
  belongs_to :word, class_name: "Glossary::Word"
  has_many :references, class_name: "Glossary::Reference", dependent: :destroy
  scope :lexicographical, -> { order(translation_text: :asc) }
end
