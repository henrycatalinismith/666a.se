class HomeController < ApplicationController
  def index
    @page_title = "666a"
    @labour_law_documents = LabourLaw::Document.published
  end
end
