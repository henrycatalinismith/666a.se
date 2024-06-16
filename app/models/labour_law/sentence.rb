class LabourLaw::Sentence < ApplicationRecord
  belongs_to :element, class_name: "LabourLaw::Element"
  has_many :words, dependent: :destroy, class_name: "LabourLaw::Word"
end
