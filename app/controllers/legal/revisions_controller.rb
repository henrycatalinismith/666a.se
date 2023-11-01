require "redcarpet"

class LegalRender < Redcarpet::Render::HTML
end

class Legal::RevisionsController < ApplicationController
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
    @elements = @revision.elements
    renderer = LegalRender.new()
    @redcarpet = Redcarpet::Markdown.new(renderer, :tables => true)
  end
end