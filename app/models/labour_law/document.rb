class LabourLaw::Document < ApplicationRecord
  has_many :revisions, dependent: :destroy

  def published_revision
    revisions.published.last
  end
end
