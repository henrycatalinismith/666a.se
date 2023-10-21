class HomeController < ApplicationController
  def index
    @page_title = "666a"
    @policies = Policy.all
  end
end
