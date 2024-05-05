class LabourLaw::Document < ApplicationRecord
  has_many :revisions, dependent: :destroy
end
