class Result < ApplicationRecord
  belongs_to :search
  has_many :notifications
  has_many :metadatas
  alias_method :metadata, :metadatas
  after_commit :document_metadata

  def document_metadata
    MetadataFetchJob.perform_later(id, document_code)
  end
end
