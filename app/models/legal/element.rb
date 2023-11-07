class Legal::Element < ApplicationRecord
  belongs_to :revision
  has_many :translations
  #validates :element_code, presence: true
  validates :element_index, presence: true
  validates :element_text, presence: true
  validates :element_type, presence: true

  def translate(locale)
    if locale == "en" then
      return Legal::Element.new(
        element_index: self.element_index,
        element_type: self.element_type,
        element_text: translations.where(translation_locale: "en").first.translation_text,
      )
    end
    return self
  end
end