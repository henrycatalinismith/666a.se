class WorkEnvironment::Document < ApplicationRecord
  has_many :notifications, class_name: "User::Notification"
  scope :chronological, -> { order(document_date: :asc) }
  scope :reverse_chronological, -> { order(document_date: :desc) }
  scope :since_launch, -> { where("document_date >= ?", "2023-10-30") }

  enum :document_direction, {
    document_incoming: 0,
    document_outgoing: 1,
  }

  enum :case_status, {
    case_ongoing: 0,
    case_concluded: 1,
  }

  rails_admin do
    object_label_method do
      :document_code
    end

    list do
      field :document_code
      field :case_name
      field :company_name
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end
end
