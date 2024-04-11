require "front_matter_parser"
require "redcarpet"

class PagesController < ApplicationController
  layout "internal"

  def show
    file = Rails.root.join("app/pages#{request.path}.md")
    render plain: "Not Found", status: 404 and return unless File.exist?(file)
    parsed = FrontMatterParser::Parser.parse_file(file)
    @data = parsed.front_matter
    puts @data.inspect
    @content = parsed.content
  end
end
