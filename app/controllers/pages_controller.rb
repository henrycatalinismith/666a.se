require "front_matter_parser"
require "redcarpet"

class PagesController < ApplicationController
  def index
    slugs = %w[
      launch-announcement
      english-translations-of-swedish-laws
      incident-report
      night-work-tech-and-swedish-labour-law
      going-open-source
      about-arbetsmiljoverkets-new-webdiarium
      we-maxed-out-sendgrids-free-tier
    ]

    @posts =
      slugs.map do |slug|
        file = Rails.root.join("app/pages/news/#{slug}.en.md")
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
    if params[:slug].nil?
      file = Rails.root.join("app/pages/about/about.en.md")
    else
      file = Rails.root.join("app/pages/about/#{params[:slug]}.en.md")
    end
    render plain: "Not Found", status: 404 and return unless File.exist?(file)
    text = File.read(file)
    unsafe_loader = ->(string) do
      Psych.safe_load(string, permitted_classes: [Date, Time])
    end
    parsed = FrontMatterParser::Parser.parse_file(file, loader: unsafe_loader)
    @data = parsed.front_matter

    if params[:slug].nil?
      @content = File.read(Rails.root.join("readme.md"))
    elsif params[:slug] == "conduct"
      @content = File.read(Rails.root.join("code_of_conduct.md"))
    elsif params[:slug] == "contributing"
      @content = File.read(Rails.root.join("contributing.md"))
    elsif params[:slug] == "license"
      @content = File.read(Rails.root.join("license.md"))
    elsif params[:slug] == "security"
      @content = File.read(Rails.root.join("security.md"))
    else
      @content = parsed.content
    end

    @page_title = @data["title"]
    render template: "pages/show", layout: "internal"
  end
end
