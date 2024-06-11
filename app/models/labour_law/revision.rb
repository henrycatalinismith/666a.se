class LabourLaw::Revision < ApplicationRecord
  belongs_to :document
  belongs_to :parent, foreign_key: :parent_id, class_name: "LabourLaw::Revision", optional: true
  has_one :child, foreign_key: :parent_id, class_name: "LabourLaw::Revision", dependent: :destroy
  has_many :elements, dependent: :destroy

  enum revision_status: {
    draft: 0,
    published: 1,
    replaced: 2,
  }
end
