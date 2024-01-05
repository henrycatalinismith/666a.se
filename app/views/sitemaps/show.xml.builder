xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc "https://666a.se/"
    xml.lastmod Time.utc(2023, 10, 31).strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  @legal_documents.each do |d|

    r = d.revisions.last

    xml.url do
      xml.loc "https://666a.se/#{d.document_code}/#{r.revision_code}"
      xml.lastmod r.updated_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end

    r.elements.where('element_type != ?', :md).each do |e|

      xml.url do
        xml.loc "https://666a.se/#{d.document_code}/#{r.revision_code}/#{e.element_code}/sv:en"
        xml.lastmod e.updated_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      end

    end

  end
end