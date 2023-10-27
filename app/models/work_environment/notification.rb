module WorkEnvironment
  class Notification < ApplicationRecord
    belongs_to :document
    belongs_to :subscription

    enum email_status: {
      email_pending: 0,
      email_success: 1,
      email_error: 2,
      email_aborted: 3,
    }
  end
end