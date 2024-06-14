class Glossary::Word < ApplicationRecord
  belongs_to :parent, class_name: "Glossary::Word", optional: true
  has_many :children, class_name: "Glossary::Word", foreign_key: :parent_id, dependent: :destroy
  has_many :translations, class_name: "Glossary::Translation", dependent: :destroy

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
