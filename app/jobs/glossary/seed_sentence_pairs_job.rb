class Glossary::SeedSentencePairsJob < ApplicationJob
  include ActiveSupport::Inflector

  queue_as :default

  def perform()
    text = <<EOS
Lagen gäller inte
1. arbete som utförs under sådana förhållanden att det inte kan anses vara arbetsgivarens uppgift att vaka över hur arbetet är ordnat,
2. arbete som utförs av arbetstagare som med hänsyn till arbetsuppgifter och anställningsvillkor har företagsledande eller därmed jämförlig ställning eller av arbetstagare som med hänsyn till sina arbetsuppgifter har förtroendet att själva disponera sin arbetstid,
3. arbete som utförs i arbetsgivarens hushåll,
4. fartygsarbete, eller
5. arbete som omfattas av lagen (2005:395) om arbetstid vid visst vägtransportarbete.
EOS
    sentences = text.split(/(?<=[\n.!?])\s+/)
    puts sentences.to_yaml
  end
end
