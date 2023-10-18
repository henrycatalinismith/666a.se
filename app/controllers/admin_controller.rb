class AdminController < ApplicationController
  layout "internal"

  def index
    @days = Day.reverse_chronological
  end

  def day
    @day = Day.find_by(date: params[:date])
  end

  def stats
  end
end