require "openai"

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
  config.log_errors = true
end

class Glossary::ImportLabourLawElementJob < ApplicationJob
  queue_as :default

  def perform(id)
    element = LabourLaw::Element.find(id)

    swedish_text = element.element_text
    english_text = element.translations.first.translation_text

    prompt = <<~EOP
      Given the following Swedish legal text and its English translation, your
      task is to produce a glossary of the advanced vocabulary. The glossary is
      a JSON array of objects containing the following properties: "word_text"
      is the column for the Swedish word, "translation_text" is for the
      corresponding English word, "source_text" is the full sentence in which
      the Swedish word appears, "target_text" is the English counterpart, and
      "root_word" is the singular, indefinite form of the Swedish word. A word
      should be included in the glossary even if it's not particularly advanced,
      but is formal, or outside of everyday conversational vocabulary. The
      returned JSON must be an array of objects, each object containing the
      properties "word_text", "translation_text", "source_text", "target_text",
      and "root_word".
    EOP

    client = OpenAI::Client.new

    response = client.chat(
        parameters: {
        model: "gpt-4o",
        response_format: { type: "json_object" },
        messages: [
          { role: "user", content: prompt + "\n" + swedish_text + "\n" + english_text },
          # { role: "user", content: swedish_text },
          # { role: "user", content: english_text },
        ],
        temperature: 0.0,
      }
    )

    puts prompt
    puts swedish_text
    puts english_text

    reference_payloads = JSON.parse(response.dig("choices", 0, "message", "content"))
    if reference_payloads["glossary"].present?
      reference_payloads = reference_payloads["glossary"]
    end

    puts reference_payloads.inspect
  end
end
