module WorkEnvironment
  class Notification < ApplicationRecord
    self.table_name = "work_environment_notifications"

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