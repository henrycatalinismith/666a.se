require "openai"

class LabourLaw::SentencePhrasesJob < ApplicationJob
  queue_as :default

  def perform(id)
    OpenAI.configure do |config|
      config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
      config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID")
      config.log_errors = true
    end

    sentence = LabourLaw::Sentence.find(id)

    prompt = <<~EOP
      Given the following Swedish legal text and its English translation, produce a JSON array of objects representing word/phrase pairs.
      For each Swedish word/phrase in the Swedish text, provide the corresponding English word/phrase from the English text.
      In cases where a Swedish word/phrase does not map cleanly to any of the words/phrases in the English text, leave the English blank.
      Take care to choose the English word or words that best matches the Swedish
      English word order often differs from Swedish, so the English word will not always be the next word in the English text.
      Sometimes, a single Swedish word may correspond to multiple English words, or vice versa.\
      For example, given "I fråga om fartygsarbete gäller lagen även när svenska fartyg används till sjöfart utanför Sveriges sjöterritorium." and "The Act also applies to work on ships even when a Swedish ship is used for maritime transport outside the territorial waters of Sweden.", the Swedish word "Sveriges" lacks a direct English equivalent.
      In these cases, it can help to expand the context around the word to find a better match, such as "Sveriges sjöterritorium" corresponding to "territorial waters of Sweden".
      So the phrase pair would be {"source_phrase": "Sveriges sjöterritorium", "target_phrase": "territorial waters of Sweden"}.

      An example follows.

      Lagens ändamål är att förebygga ohälsa och olycksfall i arbetet samt att även i övrigt uppnå en god arbetsmiljö. Lag (1994:579).

      The purpose of this Act is to prevent occupational illness and accidents and to otherwise ensure a good work environment. Act (1994:579).

      | source_word            | target_word      |
      |------------------------|------------------|
      | Lagens                 | Act              |
      | ändamål                | purpose          |
      | förebygga              | prevent          |
      | ohälsa                 | illness          |
      | olycksfall             | accidents        |
      | samt att även i övrigt | and to otherwise |
      | arbetsmiljö            | work environment |

      Another example follows.

      Denna lag gäller varje verksamhet i vilken arbetstagare utför arbete för en arbetsgivares räkning. I fråga om fartygsarbete gäller lagen även när svenska fartyg används till sjöfart utanför Sveriges sjöterritorium.

      This Act applies to every activity in which employees perform work on behalf of an employer. The Act also applies to work on ships even when a Swedish ship is used for maritime transport outside the territorial waters of Sweden.

      | source_word                  | target_word                      |
      |------------------------------|----------------------------------|
      | lag                          | Act                              |
      | gäller                       | applies                          |
      | verksamhet                   | activity                         |
      | för en arbetsgivares räkning | on behalf of an employer         |
      | fartygsarbete                | work on ships                    |
      | sjöfart                      | maritime transport               |
      | Sveriges sjöterritorium      | the territorial waters of Sweden |

      Each array element should be an object with the properties "source_phrase" and "target_phrase".
      The source phrase should be the Swedish phrase and the target phrase should be the English phrase.
      The array must be provided in JSON format.
      Do not change the text in any way.
      Nest the array in an object with the key "phrase_pairs", like this:

        {
          "phrase_pairs": [{
            "source_phrase": "Arbetsmiljölag",
            "target_phrase": "Work Environment Act"
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

    phrase_pairs = JSON.parse(
      response.dig("choices", 0, "message", "content"),
      symbolize_names: true
    )

    puts phrase_pairs.to_yaml

    if phrase_pairs[:phrase_pairs].present?
      phrase_pairs = phrase_pairs[:phrase_pairs]
    end

    phrase_pairs.each do |pair|
      next if pair[:source_phrase].blank?
      next if pair[:target_phrase].blank?
      LabourLaw::Phrase.create!(
        sentence_id: sentence.id,
        source_phrase: pair[:source_phrase],
        target_phrase: pair[:target_phrase],
      )
    end
  end
end
