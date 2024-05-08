class LabourLaw::PrintLinksJob < ApplicationJob
  queue_as :default

  def perform
    aml = LabourLaw::Document.find_by_document_code("aml")
    wip = aml.revisions.draft.first
    section_headings = wip.elements.section_heading.index_order
    section_headings.each do |e|
      if e.element_chapter != "1"
        next
      end
      path = Rails.application.routes.url_helpers.labour_law_element_path(document_slug: aml.document_slug, revision_code: wip.revision_code, element_slug: e.element_slug)
      url = "https://666a.se#{path}"
      puts "- [ ] [Chapter #{e.element_chapter} Section #{e.element_section}](#{url})"
    end
  end
end
