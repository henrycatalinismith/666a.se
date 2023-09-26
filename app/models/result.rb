class Result < ApplicationRecord
  belongs_to :search
  has_many :notifications
end
