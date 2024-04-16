class ChangeDocumentCodes < ActiveRecord::Migration[7.1]
  def change
    aml = Legal::Document.find_by(document_code: "1977:1160")
    aml.update(document_code: "aml") unless aml.nil?
    atl = Legal::Document.find_by(document_code: "1982:673")
    atl.update(document_code: "atl") unless atl.nil?
    las = Legal::Document.find_by(document_code: "1982:80")
    las.update(document_code: "las") unless las.nil?
    mbl = Legal::Document.find_by(document_code: "1976:580")
    mbl.update(document_code: "mbl") unless mbl.nil?
  end
end
