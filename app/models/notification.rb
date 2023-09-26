class Notification < ApplicationRecord
  belongs_to :refresh
  belongs_to :result
end
