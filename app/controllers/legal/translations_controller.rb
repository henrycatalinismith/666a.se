require "redcarpet"

class LegalRender < Redcarpet::Render::HTML
  def list(contents, list_type)
    if list_type == "ordered" then
      %(<ol class="list-decimal">#{contents}</ol>)
    else
      %(<ul class="">#{contents}</ul>)
    end
  end
end

class Legal::TranslationsController < ApplicationController
  layout "internal"

  def show
    @document = Legal::Document.find_by(document_code: params[:document_code])
    if @document.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end
    @revision = @document.revisions.find_by(revision_code: params[:revision_code])
    if @revision.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end
    @element = @revision.elements.find_by(element_code: params[:element_code])
    if @element.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end

    if @element.element_type == "h3" then
      next_section = @revision.elements
        .where("element_index > ?", @element.element_index)
        .where("element_type = ?", "h3")
        .order(:element_index)
        .first
      @elements = @revision.elements
        .where("element_index >= ?", @element.element_index)
        .where("element_index < ?", next_section.element_index)
        .order(:element_index)
      puts next_section.inspect
    end

    renderer = LegalRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
  end
end