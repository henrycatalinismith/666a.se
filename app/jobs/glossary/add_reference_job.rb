class Glossary::AddReferenceJob < ApplicationJob
  include ActiveSupport::Inflector

  queue_as :default

  def perform(reference_payload)
    reference_payload => {
      word_text:,
      translation_text:,
      source_text:,
      target_text:,
      element_id:,
    }

    word_slug = parameterize(word_text.downcase)
    word = Glossary::Word.find_by(word_slug: word_slug)

    if word.nil?
      word = Glossary::Word.create!(
        word_text: word_text,
        word_slug: word_slug,
        word_type: :root,
      )
    end

    translation = word.translations.find_by(translation_text: translation_text)
    if translation.nil?
      translation = word.translations.create!(
        translation_text: translation_text,
      )
    end

    reference = translation.references.find_by(
      source_text: source_text,
      target_text: target_text
    )
    if reference.nil?
      reference = translation.references.create!(
        source_text: source_text,
        target_text: target_text,
        element_id: element_id,
      )
    end
  end
end
