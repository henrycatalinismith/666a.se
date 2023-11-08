class Admin::Period::DaysController < AdminController
  layout "internal"

  def index
    @days = Period::Day.reverse_chronological
  end

  def show
    @day = Period::Day.find(params[:id])
  end

  def job
    @day = Period::Day.find(params[:id])
    WorkEnvironment::SearchJob.perform_later(@day.date, cascade: true, notify: true)
    redirect_to "/admin/period/days/#{@day.id}"
    flash[:notice] = "job queued"
  end
end