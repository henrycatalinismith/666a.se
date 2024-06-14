module Glossary::ReferencesHelper
  def bold_word(phrase, word)
    parts = phrase.split(/(#{word})/i)
    puts parts.inspect
    parts = parts.map do |part|
      if part.downcase == word.downcase
        "<strong>#{part}</strong>"
      else
        part
      end
    end
    return parts.join
  end
end
