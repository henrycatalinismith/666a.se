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
      Given the following Swedish legal text and its English translation, your task is to produce a glossary of the vocabulary.

      ## Schema

      The glossary is a JSON array of objects containing the following properties:
        "word_text" is the column for the Swedish word,
        "translation_text" is for the corresponding English word,
        "source_text" is the context sentence in which the Swedish word appears,
        "target_text" is the English counterpart context sentence,

      ## Detailed Instructions

      The "word_text" and "translation_text", properties should be in lowercase unless they are acronyms.
      The "source_text" and "target_text" properties should be limited to four words on either side of the word, or up to 8 words total if the word is at the beginning or end of the sentence.
      The returned JSON must be an array of objects, each object containing the properties "word_text", "translation_text", "source_text", and "target_text".
      The returned JSON must be an array even if it contains only one object.
      Consider the entire Swedish text and do not just return the first few words.
      The English text will contain sentences that are not present in the Swedish text. You must not include these in the glossary.
      It's acceptable to skip a word or phrase if it's a very common word like "eller", "i", or "och".
      It's also acceptable to skip things like "(2001:453)" or "(1 kap. 1 §)".

    EOP


    def generate_reference_payloads(prompt, swedish_text, english_text)
      puts "--"
      puts prompt + "\n\n" + swedish_text + "\n\n" + english_text
      puts "--"

      client = OpenAI::Client.new
      response = client.chat(
          parameters: {
          model: "gpt-3.5-turbo-1106",
          response_format: { type: "json_object" },
          messages: [
            { role: "user", content: prompt + "\n\n" + swedish_text + "\n\n" + english_text },
          ],
          temperature: 0.3,
        }
      )

      reference_payloads = JSON.parse(
        response.dig("choices", 0, "message", "content"),
        symbolize_names: true
      )

      puts reference_payloads.inspect

      if reference_payloads[:glossary].present?
        reference_payloads = reference_payloads[:glossary]
      end

      if reference_payloads.is_a?(Hash)
        reference_payloads = [reference_payloads]
      end

      reference_payloads = reference_payloads.map do |reference_payload|
        reference_payload.merge(element_id: element.id).to_h
      end
    end

    reference_payloads = []

    sentences = swedish_text.split(/(?<=[.!?])\s+/)
    sentences.each do |sentence|
      reference_payloads += generate_reference_payloads(prompt, sentence, english_text)
    end

    reference_payloads.each do |reference_payload|
      if ENV["DEBUG"].present?
        puts reference_payload.to_yaml
      else
        Glossary::AddReferenceJob.perform_now(reference_payload)
      end
    end
  end
end
