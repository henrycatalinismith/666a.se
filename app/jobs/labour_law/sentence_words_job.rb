require "openai"

class LabourLaw::SentenceWordsJob < ApplicationJob
  queue_as :default

  def perform(id)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
      config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
      config.log_errors = true
    end

    sentence = LabourLaw::Sentence.find(id)

    prompt = <<~EOP
      Given the following Swedish legal text and its English translation, produce a JSON array of objects representing word pairs.
      For each Swedish word in the Swedish text, provide the corresponding English word from the English text.
      In cases where a Swedish word does not map cleanly to any of the words in the English text, leave the English word blank.
      Take care to choose the English word or words that best matches the Swedish word.
      English word order often differs from Swedish, so the English word will not always be the next word in the English text.
      Sometimes, a single Swedish word may correspond to multiple English words, or vice versa.\
      For example, given "I fråga om fartygsarbete gäller lagen även när svenska fartyg används till sjöfart utanför Sveriges sjöterritorium." and "The Act also applies to work on ships even when a Swedish ship is used for maritime transport outside the territorial waters of Sweden.", the Swedish word "Sveriges" lacks a direct English equivalent.
      In these cases, it can help to expand the context around the word to find a better match, such as "Sveriges sjöterritorium" corresponding to "territorial waters of Sweden".
      So the word pair would be {"source_word": "Sveriges sjöterritorium", "target_word": "territorial waters of Sweden"}.
      Each array element should be an object with the properties "source_word" and "target_word".
      The source word should be the Swedish word and the target word should be the English word.
      The array must be provided in JSON format.
      Do not change the text in any way.
      Nest the array in an object with the key "word_pairs", like this:

        {
          "word_pairs": [{
            "source_word": "Arbetsmiljölag",
            "target_word": "Work Environment Act"
          }]
        }

      #{sentence.source_text}

      #{sentence.target_text}
    EOP

    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        response_format: { type: "json_object" },
        messages: [
          { role: "user", content: prompt },
        ],
        temperature: 0.0,
      }
    )

    word_pairs = JSON.parse(
      response.dig("choices", 0, "message", "content"),
      symbolize_names: true
    )

    puts word_pairs.to_yaml

    if word_pairs[:word_pairs].present?
      word_pairs = word_pairs[:word_pairs]
    end

    word_pairs.each do |pair|
      next if pair[:source_word].blank?
      next if pair[:target_word].blank?
      LabourLaw::Word.create!(
        sentence_id: sentence.id,
        source_word: pair[:source_word],
        target_word: pair[:target_word],
      )
    end
  end
end
