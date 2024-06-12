module LabourLaw::DocumentsHelper
  def legal_document_subtitle(document, revision)
    if document.document_code == "aml"
      "Version #{revision.revision_code}, English translation"
    elsif document.document_code == "mbl"
      "Version 2021:1114, English translation"
    elsif document.document_code == "las"
      "Version 2022:836, English translation"
    elsif document.document_code == "atl"
      "Version #{revision.revision_code}, English translation"
    else
      ""
    end
  end
end
