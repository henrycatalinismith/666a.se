class LabourLaw::Translation < ApplicationRecord
  belongs_to :element
  enum translation_status: {
    missing: 0,
    draft: 1,
    published: 2,
  }
end
