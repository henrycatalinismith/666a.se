class HomeController < ApplicationController
  def index
    @page_title = "666:a"
    @policies = Policy.all
  end
end
