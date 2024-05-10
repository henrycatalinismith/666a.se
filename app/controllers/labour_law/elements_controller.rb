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

class LabourLaw::ElementsController < ApplicationController
  layout "internal"

  def show
    @document = LabourLaw::Document.find_by(document_slug: params[:document_slug])
    if @document.nil?
      raise ActionController::RoutingError.new("Not Found lmao #{params[:document_slug]}")
    end
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    if @revision.nil?
      raise ActionController::RoutingError.new("Not Found lol")
    end
    @element = @revision.elements.find_by(element_slug: params[:element_slug])
    if @element.nil?
      raise ActionController::RoutingError.new("Not Found")
    end

    elements = []

    if @element.section_heading? then
      next_section = @revision.elements
        .where("element_index > ?", @element.element_index)
        .where(element_type: [1, 2])
        .order(:element_index)
        .first
      elements = @revision.elements
        .where("element_index >= ?", @element.element_index)
        .where("element_index < ?", next_section.nil? ? 9999 : next_section.element_index)
        .order(:element_index)
        .to_a
    end

    if @element.section_heading? then
      prev_h2 = @revision
        .elements
        .where("element_index < ?", @element.element_index)
        .where(element_type: [2, 3])
        .order(:element_index)
        .last
      if !prev_h2.nil? then
        elements.unshift prev_h2
      end
    end

    h1 = @revision.elements.where("element_type = ?", "h1").first
    if !h1.nil? then
      elements.unshift h1
    end

    if @document.document_code == "aml" then
      @page_title = "Chapter #{@element.element_chapter} Section #{@element.element_section} of the Swedish Work Environment Act"
    elsif @document.document_code == "mbl" then
      @page_title = "Section #{@element.element_section} of the Swedish Co-Determination Act"
    elsif @document.document_code == "las" then
      @page_title = "Section #{@element.element_section} of the Swedish Employment Protection Act"
    elsif @document.document_code == "atl" then
      @page_title = "Section #{@element.element_section} of the Swedish Working Hours Act"
    end

    left = elements.map { |e| e.translate("sv") }
    right = elements.map { |e| e.translate("en") }
    @elements = left.zip(right)

    renderer = LabourLawRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, tables: true)
  end
end
