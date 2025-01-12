require "front_matter_parser"
require "redcarpet"


class NewsController < ApplicationController
  def show
    redirects = {
      "launch-announcement" => "https://henry.catalinismith.com/2023/10/31/announcing-666a/",
      "english-translations-of-swedish-laws" => "https://henry.catalinismith.com/2023/11/14/english-translations-of-swedish-laws/",
      "incident-report" => "https://henry.catalinismith.com/2023/12/03/incident-report/",
      "night-work-tech-and-swedish-labour-law" => "https://henry.catalinismith.com/2024/01/22/night-work-tech-and-swedish-labour-law/",
      "we-maxed-out-sendgrids-free-tier" => "https://henry.catalinismith.com/2024/06/10/we-maxed-out-sendgrids-free-tier/",
      "lets-update-the-english-translation-of-the-work-environment-act" => "https://henry.catalinismith.com/2024/06/11/lets-update-the-english-translation-of-the-work-environment-act/",
      "about-arbetsmiljoverkets-new-webdiarium" => "https://henry.catalinismith.com/2024/06/06/about-arbetsmiljoverkets-new-webdiarium/",
      "all-laws-now-up-to-date" => "https://henry.catalinismith.com/2024/06/25/all-laws-now-up-to-date/",
      "accidentally-sending-too-many-http-requests" => "https://henry.catalinismith.com/2024/11/30/accidentally-sending-too-many-http-requests/",
    }
    if redirects.key?(params[:slug])
      redirect_to redirects[params[:slug]], allow_other_host: true
      return
    end

    file = Rails.root.join("app/pages/news/#{params[:slug]}.en.md")
    render plain: "Not Found", status: 404 and return unless File.exist?(file)
    text = File.read(file)
    unsafe_loader = ->(string) do
      Psych.safe_load(string, permitted_classes: [Date, Time])
    end
    parsed = FrontMatterParser::Parser.parse_file(file, loader: unsafe_loader)
    @data = parsed.front_matter
    if @data["layout"] != "post"
      raise ActionController::RoutingError, "Not Found"
    end

    @content = parsed.content
    @page_title = @data["title"]
    render template: "news/show", layout: "internal"
  end
end
