class Glossary::ImportLabourLawRevisionJob < ApplicationJob
  queue_as :default

  def perform(revision_id)
    revision = LabourLaw::Revision.find(revision_id)
    elements = revision.elements.where(element_type: [
      :paragraph_text,
      :chapter_heading,
      :group_heading,
      :document_heading,
    ])

    already_imported = Glossary::Sentence
      .where(element_id: elements.pluck(:id))
      .pluck(:element_id)

    elements = elements.where.not(id: already_imported)

    puts elements.count

    elements.each do |element|
      Glossary::ImportLabourLawElementJob.perform_now(element.id)
    end
  end
end
