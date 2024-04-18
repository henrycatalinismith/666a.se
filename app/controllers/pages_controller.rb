require "front_matter_parser"
require "redcarpet"

class PagesController < ApplicationController
  def index
    slugs = %w[
      launch-announcement
      english-translations-of-swedish-laws
      incident-report
      night-work-tech-and-swedish-labour-law
    ]

    @posts =
      slugs.map do |slug|
        file = Rails.root.join("app/pages/#{slug}.en.md")
        text = File.read(file)
        unsafe_loader = ->(string) do
          Psych.safe_load(string, permitted_classes: [Date, Time])
        end
        parsed =
          FrontMatterParser::Parser.parse_file(file, loader: unsafe_loader)

        {
          title: parsed.front_matter["title"],
          date: parsed.front_matter["date"],
          body: parsed.content
        }
      end
  end

  def show
    file = Rails.root.join("app/pages#{request.path}.en.md")
    render plain: "Not Found", status: 404 and return unless File.exist?(file)
    text = File.read(file)
    unsafe_loader = ->(string) do
      Psych.safe_load(string, permitted_classes: [Date, Time])
    end
    parsed = FrontMatterParser::Parser.parse_file(file, loader: unsafe_loader)
    @data = parsed.front_matter
    @content = parsed.content
    @page_title = @data["title"]
    render template: "pages/show", layout: "internal"
  end
end
