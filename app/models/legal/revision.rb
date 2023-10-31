class Legal::Revision < ApplicationRecord
  belongs_to :document
  has_many :elements
end
