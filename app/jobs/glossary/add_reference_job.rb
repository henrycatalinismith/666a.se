class Glossary::AddReferenceJob < ApplicationJob
  include ActiveSupport::Inflector

  queue_as :default

  def perform(reference_payload)
    reference_payload => {
      root_text:,
      word_text:,
      translation_text:,
      source_text:,
      target_text:,
      element_id:,
    }

    root_slug = parameterize(root_text)
    word_slug = parameterize(root_text)

    root = Glossary::Word.find_by(word_slug: root_slug)
    word = Glossary::Word.find_by(word_slug: word_slug)

    if root.nil?
      root = Glossary::Word.create!(
        word_text: root_text,
        word_slug: root_slug,
        word_type: :root,
      )
    end

    if root_slug == word_slug
      word = root
    elsif word.nil?
      word = root.children.create!(
        word_text: word_text,
        word_slug: word_slug,
        word_type: :variant,
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
