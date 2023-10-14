class Document < ApplicationRecord
  enum document_direction: { incoming: 0, outgoing: 1 }
  enum case_status: { ongoing: 0, completed: 1 }
end
