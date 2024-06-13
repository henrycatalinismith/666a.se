class Admin::TimePeriod::WeeksController < AdminController
  layout "internal"

  def index
    @weeks = TimePeriod::Week.all.reverse_chronological
  end

  def show
    @week = TimePeriod::Week.find(params[:id])
    match = @week.week_code.match(/(\d{4})-W(\d{2})/)
    year = match[1].to_i
    week = match[2].to_i

    prev_week = week - 1
    prev_year = week - 1 > 0 ? year : year - 1
    prev_code = "#{prev_year}-W#{prev_week.to_s.rjust(2, '0')}"
    @prev = TimePeriod::Week.find_by_week_code(prev_code)

    next_week = week + 1 > 52 ? 1 : week + 1
    next_year = next_week == 1 ? year + 1 : year
    next_code = "#{next_year}-W#{next_week.to_s.rjust(2, '0')}"
    @next = TimePeriod::Week.find_by_week_code(next_code)
  end

  def job
    @week = TimePeriod::Week.find(params[:id])
    WorkEnvironment::WeekJob.perform_later(@week.week_code, cascade: true, force: true, notify: false)
    redirect_to "/legacy_admin/time_period/weeks/#{@week.id}"
    flash[:notice] = "job queued"
  end
end
