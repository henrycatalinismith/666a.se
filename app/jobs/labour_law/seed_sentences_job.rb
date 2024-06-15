class LabourLaw::SeedSentencesJob < ApplicationJob
  queue_as :default

  def perform(revision_id)
    revisions = LabourLaw::Revision.all
    revisions.each do |revision|
      LabourLaw::RevisionSentencesJob.perform_now(revision.id)
    end
  end
end
