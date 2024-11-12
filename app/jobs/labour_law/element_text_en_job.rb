class LabourLaw::ElementTextEnJob < ApplicationJob
  queue_as :default

  def perform
    elements = LabourLaw::Element.all
    elements.each do |e|
      e.update element_text_en: e.translations.first.translation_text
    end
  end
end
