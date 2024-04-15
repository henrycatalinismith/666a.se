require "front_matter_parser"
require "redcarpet"

class PagesController < ApplicationController
  layout "internal"

  def show
    file = Rails.root.join("app/pages#{request.path}.md")
    render plain: "Not Found", status: 404 and return unless File.exist?(file)
    text = File.read(file)
    unsafe_loader = ->(string) { Psych.safe_load(string, permitted_classes: [Date, Time]) }
    parsed = FrontMatterParser::Parser.parse_file(file, loader: unsafe_loader)
    @data = parsed.front_matter
    puts @data.inspect
    @content = parsed.content
  end
end
