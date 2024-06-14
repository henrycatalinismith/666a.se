class Glossary::ImportLabourLawParagraphElementsJob < ApplicationJob
  queue_as :default

  def perform(revision_id)
    revision = LabourLaw::Revision.find(revision_id)
    paragraph_elements = revision.elements.paragraph_text

    already_imported = Glossary::Reference
      .where(element_id: paragraph_elements.pluck(:id))
      .pluck(:element_id)

    paragraph_elements = paragraph_elements.where.not(id: already_imported)

    puts paragraph_elements.count

    paragraph_elements.each do |element|
      Glossary::ImportLabourLawElementJob.perform_now(element.id)
    end
  end
end
