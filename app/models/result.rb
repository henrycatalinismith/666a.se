class Result < ApplicationRecord
  belongs_to :search
  has_many :notifications
  after_commit :document_metadata

  def document_metadata
    puts "after_commit: begin"
    DocumentMetadataJob.perform_later(document_code)
    puts "after_commit: end"
  end
end
