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

    if request.path == "/about"
      @content = File.read(Rails.root.join("readme.md"))
    elsif request.path == "/conduct"
      @content = File.read(Rails.root.join("code_of_conduct.md"))
    elsif request.path == "/contributing"
      @content = File.read(Rails.root.join("contributing.md"))
    elsif request.path == "/license"
      @content = File.read(Rails.root.join("license.md"))
    elsif request.path == "/security"
      @content = File.read(Rails.root.join("security.md"))
    else
      @content = parsed.content
    end

    @page_title = @data["title"]
    render template: "pages/show", layout: "internal"
  end
end
