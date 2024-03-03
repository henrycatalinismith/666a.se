xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "666:a"
    xml.description "Work environment email alerts"
    xml.link "https://666a.se"

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description markdown.render(post.body_en)
        xml.pubDate post.date.rfc822
        xml.link "https://666a.se/#{post.date.strftime("%Y/%m/%d")}/#{post.slug}"
        xml.guid "https://666a.se/#{post.date.strftime("%Y/%m/%d")}/#{post.slug}"
      end
    end
  end
end