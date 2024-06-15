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

    swedish_text = element.element_text
    english_text = element.translations.first.translation_text

    prompt = <<~EOP
      Given the following Swedish legal text and its English translation, produce a an array of sentence pairs.
      For each Swedish sentence, provide the corresponding English sentence.
      Each array element should be an object with the properties "swedish_text" and "english_text".
      The array must be provided in JSON format.
      Exclude sentences of the form "Lag (1994:579)" no matter what numbers are used.

      #{swedish_text}

      #{english_text}
    EOP

    client = OpenAI::Client.new
    response = client.chat(
        parameters: {
        model: "gpt-3.5-turbo-1106",
        response_format: { type: "json_object" },
        messages: [
          { role: "user", content: prompt },
        ],
        temperature: 0.3,
      }
    )

    sentence_pairs = JSON.parse(
      response.dig("choices", 0, "message", "content"),
      symbolize_names: true
    )

    puts sentence_pairs.to_yaml

    sentence_pairs.each do |pair|
      existing_sentence = Glossary::Sentence.where(source_text: swedish_text)
      if existing_sentence.empty?
        Glossary::Sentence.create!(
          element_id: element.id,
          source_text: pair[:swedish_text],
          target_text: pair[:english_text],
        )
      end
    end
  end
end
