module WorkEnvironment
  class Document < ApplicationRecord
    self.table_name = "work_environment_documents"

    has_many :notifications

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
end