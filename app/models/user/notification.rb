class User::Notification < ApplicationRecord
  belongs_to :document, class_name: "WorkEnvironment::Document"
  belongs_to :subscription
  has_one :account, through: :subscription
  scope :chronological, -> { order(created_at: :asc) }
  scope :reverse_chronological, -> { order(created_at: :desc) }

  enum email_status: {
    email_pending: 0,
    email_success: 1,
    email_error: 2,
    email_aborted: 3,
  }

  rails_admin do
    list do
      field :document
      field :account
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end

  def icon
    if email_error?
      return "fa-circle-exclamation"
    end
    if email_success?
      return "fa-check"
    end
    if email_pending?
      return "fa-hourglass-start"
    end
  end
end
