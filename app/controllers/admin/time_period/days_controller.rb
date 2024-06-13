class Admin::TimePeriod::DaysController < AdminController
  layout "internal"

  def index
    @days = TimePeriod::Day.reverse_chronological
  end

  def show
    @day = TimePeriod::Day.find(params[:id])
  end

  def job
    @day = TimePeriod::Day.find(params[:id])
    WorkEnvironment::DayJob.perform_later(
      @day.date,
      cascade: true,
      force: true,
      notify: true,
      purge: true
    )
    redirect_to "/legacy_admin/time_period/days/#{@day.id}"
    flash[:notice] = "job queued"
  end
end
