class Admin::StatisticsController < AdminController
  layout "internal"

  def index
  end

  def december_comparison
  end

  def document_lag
    @days = TimePeriod::Day.chronological.since_launch

    @avg = {}
    @max = {}

    @days.each do |day|
      documents = day.documents
      created_at = documents.map(&:created_at).map(&:to_date)
      all = created_at.map { |c| (c - day.date).to_i }
      if all.count == 0 then
        avg = 0
        max = 0
      else
        avg = all.sum / all.count
        max = all.max
      end
      @avg[day.ymd] = avg
      @max[day.ymd] = max
    end

    puts @lag.inspect
  end

  def diarium
    @days = TimePeriod::Day.chronological.since_launch.map(&:date) + [Date.today]
  end

  def email_metrics
    @days = TimePeriod::Day.chronological.last_two_weeks.map(&:date) + [Date.today]
  end

  def kitchen_sink
    @days = TimePeriod::Day.chronological.since_launch.map(&:date) + [Date.today]
  end

  def user_growth
    @days = TimePeriod::Day.chronological.since_launch.map(&:date) + [Date.today]
  end
end