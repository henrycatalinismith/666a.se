class Admin::Period::WeeksController < AdminController
  layout "internal"

  def index
    @weeks = Period::Week.all.reverse_chronological
  end

  def show
    @week = Period::Week.find(params[:id])
    match = @week.week_code.match(/(\d{4})-W(\d{2})/)
    year = match[1].to_i
    week = match[2].to_i

    prev_week = week - 1
    prev_year = week - 1 > 0 ? year : year - 1
    prev_code = "#{prev_year}-W#{prev_week.to_s.rjust(2, '0')}"
    @prev = Period::Week.find_by_week_code(prev_code)

    next_week = week + 1 > 52 ? 1 : week + 1
    next_year = next_week == 1 ? year + 1 : year
    next_code = "#{next_year}-W#{next_week.to_s.rjust(2, '0')}"
    @next = Period::Week.find_by_week_code(next_code)
  end
end