class Translation::GlossaryWord < ApplicationRecord
  belongs_to :parent, class_name: "Translation::GlossaryWord", optional: true
  enum word_type: {
    root: 0,
    variant: 1,
  }
  scope :lexicographical, -> { order(word_text: :asc) }
end
