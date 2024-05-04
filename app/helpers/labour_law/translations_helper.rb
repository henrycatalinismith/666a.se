module LabourLaw::TranslationsHelper
  def translation_url(element)
    if element.element_chapter.present?
      "/chapter-#{element.element_chapter}-section-#{element.element_section}-of-#{element.revision.document.document_code}-v#{element.revision.revision_code}-in-english"
    else
      "/section-#{element.element_section}-of-#{element.revision.document.document_code}-v#{element.revision.revision_code}-in-english"
    end
  end
end
