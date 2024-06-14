class Glossary::TestAddReferenceJob < ApplicationJob
  queue_as :default

  def perform()
    Glossary::AddReferenceJob.perform_now({
      root_text: "förebygga",
      word_text: "förebygga",
      translation_text: "prevent",
      source_text: "Lagens ändamål är att förebygga ohälsa och olycksfall i arbetet samt att även i övrigt uppnå en god arbetsmiljö.",
      target_text: "The purpose of this Act is to prevent occupational illness and accidents and to otherwise ensure a good work environment. ",
    })
  end
end
