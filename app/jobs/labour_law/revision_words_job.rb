class LabourLaw::RevisionWordsJob < ApplicationJob
  queue_as :default

  def perform(revision_id)
    revision = LabourLaw::Revision.find(revision_id)
    elements = revision.elements.where(element_type: [
      :paragraph_text,
      :chapter_heading,
      :group_heading,
      :document_heading,
    ])

    puts elements.count

    elements.each do |element|
      sentences = element.sentences
      sentences.each do |sentence|
        LabourLaw::SentenceWordsJob.perform_now(sentence.id)
      end
    end
  end
end
