class Admin::StatsController < AdminController
  layout "internal"

  def index
  end

  def comparison
  end

  def document_lag
    @days = Period::Day.chronological.since_launch

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
end