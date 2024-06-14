class Glossary::Translation < ApplicationRecord
  belongs_to :word, class_name: "Glossary::Word"
  scope :lexicographical, -> { order(translation_text: :asc) }
end
