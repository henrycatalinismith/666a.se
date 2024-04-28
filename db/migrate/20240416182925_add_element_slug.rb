class AddElementSlug < ActiveRecord::Migration[7.1]
  def change
    elements = LabourLaw::Element.all
    elements.each do |element|
      chapter = element.element_code.match(/\AK([0-9])\Z/)
      chapter_paragraph = element.element_code.match(/\AK([0-9])P([0-9]+[a-z]?)\Z/)
      chapter_paragraph_section = element.element_code.match(/\AK([0-9])P([0-9]+[a-z]?)S([0-9]+)\Z/)
      paragraph = element.element_code.match(/\AP([0-9]+[a-z]?)\Z/)
      paragraph_section = element.element_code.match(/\AP([0-9]+[a-z]?)S([0-9]+)\Z/)
      if chapter then
        element.update(element_code: "chapter-#{chapter[1]}")
      elsif chapter_paragraph then
        element.update(element_code: "chapter-#{chapter_paragraph[1]}-section-#{chapter_paragraph[2]}")
      elsif chapter_paragraph_section then
        element.update(element_code: "chapter-#{chapter_paragraph_section[1]}-section-#{chapter_paragraph_section[2]}-paragraph-#{chapter_paragraph_section[3]}")
      elsif paragraph then
        element.update(element_code: "section-#{paragraph[1]}")
      elsif paragraph_section then
        element.update(element_code: "section-#{paragraph_section[1]}-paragraph-#{paragraph_section[2]}")
      end
    end
  end
end
