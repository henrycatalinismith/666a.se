class Admin::DaysController < AdminController
  layout "internal"

  def index
    @days = Day.reverse_chronological
  end

  def show
    @day = Day.find_by(date: params[:date])
  end

  def job
    @day = Day.find_by(date: params[:date])
    WorkEnvironment::SearchJob.perform_later(@day.date, cascade: true, notify: true)
    redirect_to "/admin/days/#{@day.date.strftime("%Y-%m-%d")}"
    flash[:notice] = "job queued"
  end
end