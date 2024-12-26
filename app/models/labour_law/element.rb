class LabourLaw::Element < ApplicationRecord
  belongs_to :revision
  has_many :translations, dependent: :destroy
  has_many :sentences, dependent: :destroy, class_name: "LabourLaw::Sentence"
  validates :element_index, presence: true
  validates :element_text, presence: true
  validates :element_type, presence: true

  enum :element_type, {
    paragraph_text: 0,
    section_heading: 1,
    chapter_heading: 2,
    group_heading: 3,
    document_heading: 4,
  }

  enum :translation_status, {
    translation_missing: 0,
    translation_draft: 1,
    translation_published: 2,
  }

  scope :index_order, -> { order(:element_index) }

  def translate(locale)
    if locale == "en" then
      return LabourLaw::Element.new(
        element_index: self.element_index,
        element_type: self.element_type,
        element_text: translations.where(translation_locale: "en").first.translation_text,
      )
    end
    return self
  end

  def next
    revision
      .elements
      .where("element_index > ?", element_index)
      .order(:element_index)
      .first
  end

  def prev
    revision
      .elements
      .where("element_index < ?", element_index)
      .order(:element_index)
      .last
  end
end
