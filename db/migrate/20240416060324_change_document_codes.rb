class ChangeDocumentCodes < ActiveRecord::Migration[7.1]
  def change
    Legal::Document.find_by(document_code: "1977:1160").update(document_code: "aml")
    Legal::Document.find_by(document_code: "1982:673").update(document_code: "atl")
    Legal::Document.find_by(document_code: "1982:80").update(document_code: "las")
    Legal::Document.find_by(document_code: "1976:580").update(document_code: "mbl")
  end
end
