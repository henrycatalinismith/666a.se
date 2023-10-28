class Legal::Document < ApplicationRecord
  has_many :revisions
end
