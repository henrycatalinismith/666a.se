module LabourLaw::ElementsHelper
  def section_title(element)
    document = element.revision.document
    revision = element.revision
    if document.document_code == "aml" then
      "Chapter #{element.element_chapter} Section #{element.element_section} of the Work Environment Act"
    elsif document.document_code == "mbl" then
      "Section #{element.element_section} of the Co-Determination Act"
    elsif document.document_code == "las" then
      "Section #{element.element_section} of the Employment Protection Act"
    elsif document.document_code == "atl" then
      "Section #{element.element_section} of the Working Hours Act"
    end
  end

  def section_heading(element)
    if element.paragraph_text?
      index = element.element_index
      return element.revision.elements.section_heading.where("element_index < ?", index).order(:element_index).last
    end
    return element
  end
end
