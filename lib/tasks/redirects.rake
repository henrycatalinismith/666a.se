namespace :redirects do
  task generate: :environment do
    redirects = File.open("public/_redirects", "w")
    redirects.puts "/labour-law https://lagstiftning.codeberg.page/ 301"
    @documents = LabourLaw::Document.published
    @documents.each do |d|
      r = d.revisions.published.last
      path = Rails.application.routes.url_helpers.labour_law_revision_path(document_slug: d.document_slug, revision_code: r.revision_code)
      if d.document_code == "aml" then
        url = "https://lagstiftning.codeberg.page/arbetsmiljolagen/2023:349/"
      elsif d.document_code == "mbl" then
        url = "https://lagstiftning.codeberg.page/medbestammandelagen/2021:1114/"
      elsif d.document_code == "las" then
        url = "https://lagstiftning.codeberg.page/lagen-om-anstallningsskydd/2022:836/"
      elsif d.document_code == "atl" then
        url = "https://lagstiftning.codeberg.page/arbetstidslagen/2022:450/"
      end
      redirects.puts "#{path} #{url} 301"
      r.elements.section_heading.each do |e|
        path = Rails.application.routes.url_helpers.labour_law_element_path(document_slug: d.document_slug, revision_code: r.revision_code, element_slug: e.element_slug)
        if d.document_code == "aml" then
          url = "https://lagstiftning.codeberg.page/arbetsmiljolagen/2023:349/#{e.element_slug}"
        elsif d.document_code == "mbl" then
          url = "https://lagstiftning.codeberg.page/medbestammandelagen/2021:1114/#{e.element_slug}"
        elsif d.document_code == "las" then
          url = "https://lagstiftning.codeberg.page/lagen-om-anstallningsskydd/2022:836/#{e.element_slug}"
        elsif d.document_code == "atl" then
          url = "https://lagstiftning.codeberg.page/arbetstidslagen/2022:450/#{e.element_slug}"
        end
        redirects.puts "#{path} #{url} 301"
      end
    end
  end
end
