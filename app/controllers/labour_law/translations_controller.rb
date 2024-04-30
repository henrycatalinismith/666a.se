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

class LabourLaw::TranslationsController < ApplicationController
  layout "internal"

  def show
    @document = LabourLaw::Document.find_by(document_code: params[:document_code])
    if @document.nil? then
      raise ActionController::RoutingError.new("Not Found lmao #{params[:document_code]}")
    end
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    if @revision.nil? then
      raise ActionController::RoutingError.new("Not Found lol")
    end
    @element = @revision.elements.find_by(element_code: params[:element_code])
    if @element.nil? or @element.element_type == "md" or @element.element_code.match(/\AK.\Z/) then
      raise ActionController::RoutingError.new("Not Found oh no #{params[:element_code]}")
    end

    elements = []

    if @element.element_type == "h3" or @element.element_type == "h2" then
      next_section = @revision.elements
        .where("element_index > ?", @element.element_index)
        .where("element_type = ?", @element.element_type)
        .order(:element_index)
        .first
      elements = @revision.elements
        .where("element_index >= ?", @element.element_index)
        .where("element_index < ?", next_section.nil? ? 9999 : next_section.element_index)
        .order(:element_index)
        .to_a
    end

    if @element.element_type == "h3" then
      prev_h2 = @revision
        .elements
        .where("element_index < ?", @element.element_index)
        .where("element_type = ?", "h2")
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
      h2_match = prev_h2.translations.first.translation_text.match(/\AChapter (\d+)/)
      h3_match = @element.translations.first.translation_text.match(/\ASection ([0-9a-z\.]+)/)
      @page_title = "Chapter #{h2_match[1]} Section #{h3_match[1]} of the Swedish Work Environment Act"
    elsif @document.document_code == "mbl" then
      h3_match = @element.translations.first.translation_text.match(/\ASection ([0-9a-z\.]+)/)
      @page_title = "Section #{h3_match[1]} of the Swedish Co-Determination Act"
    elsif @document.document_code == "las" then
      h3_match = @element.translations.first.translation_text.match(/\ASection ([0-9a-z\.]+)/)
      @page_title = "Section #{h3_match[1]} of the Swedish Employment Protection Act"
    elsif @document.document_code == "atl" then
      h3_match = @element.translations.first.translation_text.match(/\ASection ([0-9a-z\.]+)/)
      @page_title = "Section #{h3_match[1]} of the Swedish Working Hours Act"
    end

    left = elements.map { |e| e.translate("sv") }
    right = elements.map { |e| e.translate("en") }
    @elements = left.zip(right)

    renderer = LabourLawRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, tables: true)
  end
end