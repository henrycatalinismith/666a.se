class LabourLaw::Phrase < ApplicationRecord
  belongs_to :sentence, class_name: "LabourLaw::Sentence"
end
