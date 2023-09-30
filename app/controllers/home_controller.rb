class HomeController < ApplicationController
  def index
    render(HomePageComponent.new())
  end
end
