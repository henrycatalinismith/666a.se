require "front_matter_parser"
require "redcarpet"

class NewsController < ApplicationController
  def show
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
