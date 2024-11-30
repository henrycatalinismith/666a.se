class TimePeriod::Week < ApplicationRecord
  has_many :days

  scope :chronological, -> { order(week_code: :asc) }
  scope :reverse_chronological, -> { order(week_code: :desc) }
  scope :since_launch, -> { where("week_code >= ?", "2023-W44") }

  rails_admin do
    object_label_method do
      :week_code
    end

    list do
      field :week_code
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end
end
