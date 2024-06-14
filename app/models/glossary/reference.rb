class Glossary::Reference < ApplicationRecord
  belongs_to :translation, class_name: "Glossary::Translation"
end
