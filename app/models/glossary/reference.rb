class Glossary::Reference < ApplicationRecord
  belongs_to :translation, class_name: "Glossary::Translation"
  belongs_to :element, class_name: "LabourLaw::Element"
end
