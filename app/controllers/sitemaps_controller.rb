class SitemapsController < ApplicationController
  def show
    @legal_documents = Legal::Document.all

    respond_to do |format|
      format.xml
    end
  end
end