require "openai"

class Glossary::ImportLabourLawElementJob < ApplicationJob
  queue_as :default

  def perform(id)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
      config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
      config.log_errors = true
    end

    element = LabourLaw::Element.find(id)

    source_text = element.element_text
    target_text = element.translations.first.translation_text

    prompt = <<~EOP
      Given the following Swedish legal text and its English translation, produce a an array of sentence pairs.
      For each Swedish sentence, provide the corresponding English sentence.
      Each array element should be an object with the properties "source_text" and "target_text".
      The source text should be the Swedish sentence and the target text should be the English sentence.
      The array must be provided in JSON format.
      Exclude sentences of the form "Lag (1994:579)" no matter what numbers are used.
      If a sentence is a list of items, provide each item as a separate sentence pair.
      Preserve list item numbering and lettering, so that if the input text is "Lista:\n\n1. Första punkten" and "List:\n\n1. First point", the output should be [{ "source_text": "Lista:", "target_text": "List:" }, { "source_text": "1. Första punkten", "target_text": "2. First point" }].
      Do not change the text in any way.
      Nest the array in an object with the key "sentence_pairs", like this:

        {
          "sentence_pairs": [{
            "source_text": "Arbetsmiljölag (1977:1160)",
            "target_text": "Work Environment Act (1977:1160)"
          }]
        }

      #{source_text}

      #{target_text}
    EOP

    client = OpenAI::Client.new
    response = client.chat(
        parameters: {
        model: "gpt-3.5-turbo-1106",
        response_format: { type: "json_object" },
        messages: [
          { role: "user", content: prompt },
        ],
        temperature: 0.0,
      }
    )

    sentence_pairs = JSON.parse(
      response.dig("choices", 0, "message", "content"),
      symbolize_names: true
    )

    puts sentence_pairs.to_yaml

    if sentence_pairs[:sentence_pairs].present?
      sentence_pairs = sentence_pairs[:sentence_pairs]
    end

    sentence_pairs.each do |pair|
      Glossary::Sentence.create!(
        element_id: element.id,
        source_text: pair[:source_text],
        target_text: pair[:target_text],
      )
    end
  end
end
