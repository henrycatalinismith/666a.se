class Glossary::Word < ApplicationRecord
  belongs_to :parent, class_name: "Glossary::Word", optional: true
  enum word_type: {
    root: 0,
    variant: 1,
  }
  scope :lexicographical, -> { order(word_text: :asc) }

  before_save :nullify_parent_for_root

  def nullify_parent_for_root
    if self.root?
      self.parent = nil
    end
  end
end
