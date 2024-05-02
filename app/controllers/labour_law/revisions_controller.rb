require "redcarpet"

class LabourLawRender < Redcarpet::Render::HTML
  def list(contents, list_type)
    if list_type == :ordered then
      %(<ol class="list-decimal ps-6 pt-4">#{contents}</ol>)
    else
      %(<ul class="list-disc ps-6 pt-4">#{contents}</ul>)
    end
  end
end

class LabourLaw::RevisionsController < ApplicationController
  layout "internal"

  def show
    @document = LabourLaw::Document.find_by(document_code: params[:document_code])
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

    elements = @revision.elements.index_order

    left = elements.map { |e| e.translate("sv") }
    right = elements.map { |e| e.translate("en") }
    @elements = left.zip(right)

    renderer = LabourLawRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, tables: true)
  end
end
