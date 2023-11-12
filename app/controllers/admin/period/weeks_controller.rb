class Admin::Period::WeeksController < AdminController
  layout "internal"

  def index
    @weeks = Period::Week.all
  end

  def show
    @week = Period::Week.find(params[:id])
  end
end