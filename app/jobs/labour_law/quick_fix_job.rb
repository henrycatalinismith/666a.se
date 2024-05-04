class LabourLaw::QuickFixJob < ApplicationJob
  queue_as :default

  def perform
    elements = LabourLaw::Element.index_order.all.slice(1000, 1000)
    elements.each_with_index do |element, i|
      puts "LabourLaw::Element.find(\"#{element.id}\").update(element_type: :#{element.element_type}) # #{i}"
    end
  end
end
