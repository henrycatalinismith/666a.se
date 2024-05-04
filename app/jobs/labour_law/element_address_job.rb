class LabourLaw::ElementAddressJob < ApplicationJob
  queue_as :default

  def perform
    elements = LabourLaw::Element.all
    elements.each do |element|
      puts element.element_code
      codes = element.element_code.match(
        %r{(chapter-(?<chapter>[^-]+)-?)?(section-(?<section>[^-]+)-?)?(paragraph-(?<paragraph>[^-]+))?}
      )
      if codes.nil?
        next
      end
      element.update(
        element_chapter: codes[:chapter],
        element_section: codes[:section],
        element_paragraph: codes[:paragraph]
      )
    end
  end
end
