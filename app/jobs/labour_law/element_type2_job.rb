require "time"

class LabourLaw::ElementType2Job < ApplicationJob
  queue_as :default

  def perform
    elements = LabourLaw::Element.all
    elements.each do |element|
      puts element.element_type

      case element.element_type
      when "h1"
        element_type = :document_heading

      when "h2"
        element_type = element.element_chapter.present? ? :chapter_heading : :group_heading

      when "h3"
        element_type = :section_heading

      when "md"
        element_type = :paragraph_text

      end

      element.update(element_type: element_type)
    end
  end
end
