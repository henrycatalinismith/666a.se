module Legal::DocumentsHelper
  def legal_document_title(document)
    if document.document_code == "aml"
      "The Swedish Work Environment Act"
    elsif document.document_code == "mbl"
      "The Swedish Co-Determination Act"
    elsif document.document_code == "las"
      "The Swedish Employment Protection Act"
    elsif document.document_code == "atl"
      "The Swedish Working Hours Act"
    else
      ""
    end
  end

  def legal_document_subtitle(document)
    if document.document_code == "aml"
      "Version 2014:659, English translation"
    elsif document.document_code == "mbl"
      "Version 2021:1114, English translation"
    elsif document.document_code == "las"
      "Version 2022:836, English translation"
    elsif document.document_code == "atl"
      "Version 2013:611, English translation"
    else
      ""
    end
  end
end
