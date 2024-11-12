class LabourLaw::TranslationSuggestionsJob < ApplicationJob
  queue_as :default

  def perform(element_id)
    element = LabourLaw::Element.find(element_id)
    words = element.element_text_sv.split(" ")
    counts = {}

    length = words.length

    while length > 0
      offset = 0
      while offset + length <= words.length
        phrase = words[offset, length].join(" ")
        phrases = LabourLaw::Phrase.where("source_phrase LIKE ?", "%#{phrase}%")
        # puts "Phrase: #{phrase} #{phrases.count}"
        if phrases.count > 0
          counts[phrase] = phrases.count
        end
        offset += 1
      end
      length -= 1
    end

    puts counts.sort { |a, b| b[1] <=> a[1] }.to_yaml
  end
end
