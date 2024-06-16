class LabourLaw::Sentence < ApplicationRecord
  belongs_to :element, class_name: "LabourLaw::Element"
  has_many :phrases, dependent: :destroy, class_name: "LabourLaw::Phrase"
end
