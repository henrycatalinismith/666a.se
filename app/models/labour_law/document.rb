class LabourLaw::Document < ApplicationRecord
  has_many :revisions, dependent: :destroy

  enum document_status: {
    draft: 0,
    published: 1,
  }

  def published_revision
    revisions.published.last
  end
end
