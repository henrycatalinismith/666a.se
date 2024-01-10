class WorkEnvironment::Document < ApplicationRecord
  has_many :notifications
  scope :chronological, -> { order(document_date: :asc) }
  scope :since_launch, -> { where("document_date >= ?", "2023-10-30") }

  enum document_direction: {
    document_incoming: 0,
    document_outgoing: 1,
  }

  enum case_status: {
    case_ongoing: 0,
    case_concluded: 1,
  }

  enum notification_status: {
    notification_needless: 0,
    notification_pending: 1,
    notification_success: 2,
    notification_error: 3,
    notification_aborted: 4,
  }
end