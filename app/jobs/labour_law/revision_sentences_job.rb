class LabourLaw::RevisionSentencesJob < ApplicationJob
  queue_as :default

  def perform(revision_id)
    revision = LabourLaw::Revision.find(revision_id)
    elements = revision.elements.where(element_type: [
      :paragraph_text,
      :chapter_heading,
      :group_heading,
      :document_heading,
    ])

    already_imported = LabourLaw::Sentence
      .where(element_id: elements.pluck(:id))
      .pluck(:element_id)

    elements = elements.where.not(id: already_imported)

    puts elements.count

    elements.each do |element|
      next if element.element_text_en.blank?
      LabourLaw::ElementSentencesJob.perform_now(element.id)
    end
  end
end
