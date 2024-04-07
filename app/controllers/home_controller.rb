class HomeController < ApplicationController
  def index
    @page_title = "6:6:6a"
    @policies = Policy.all
  end
end
