require "redcarpet"

class LegalRender < Redcarpet::Render::HTML
  def list(contents, list_type)
    if list_type == :ordered then
      %(<ol class="list-decimal ps-6 pt-4">#{contents}</ol>)
    else
      %(<ul class="list-disc ps-6 pt-4">#{contents}</ul>)
    end
  end
end

class Legal::RevisionsController < ApplicationController
  layout "internal"

  def show
    @document = Legal::Document.find_by(document_code: params[:document_code])
    if @document.nil? then
      raise ActionController::RoutingError.new("Not Found doc")
    end
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    if @revision.nil? then
      raise ActionController::RoutingError.new("Not Found revs " + params[:revision_code])
    end

    if @document.document_code == "aml" then
      @page_title = "The Swedish Work Environment Act"
    elsif @document.document_code == "mbl" then
      @page_title = "The Swedish Co-Determination Act"
    elsif @document.document_code == "las" then
      @page_title = "The Swedish Employment Protection Act"
    elsif @document.document_code == "atl" then
      @page_title = "The Swedish Working Hours Act"
    end

    left = @revision.elements.map { |e| e.translate("sv") }
    right = @revision.elements.map { |e| e.translate("en") }
    @elements = left.zip(right)

    renderer = LegalRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, tables: true)
  end
end
