class LabourLaw::Revision < ApplicationRecord
  belongs_to :document
  has_many :elements

  enum revision_status: {
    draft: 0,
    published: 1,
  }
end
