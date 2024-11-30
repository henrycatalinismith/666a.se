class WorkEnvironment::Search < ApplicationRecord
  belongs_to :day, class_name: "TimePeriod::Day"

  enum result_status: {
    result_pending: 0,
    result_fetching: 1,
    result_ready: 2,
    result_error: 3,
    result_aborted: 4,
  }

  scope :retrospective, ->(date) { where("created_at >= ?", date + 1.day) }
  scope :latest, -> { order(created_at: :desc) }
  scope :chronological, -> { order(date: :asc) }
  scope :reverse_chronological, -> { order(date: :desc) }

  rails_admin do
    object_label_method do
      :search_label
    end

    list do
      field :day
      field :page_number
      field :created_at
      field :updated_at
      sort_by :created_at
    end
  end

  def search_label
    "#{day.date.strftime("%Y-%m-%d")}:#{page_number}"
  end

  def parameters(page = 1)
    {
      FromDate: day.date.strftime("%Y-%m-%d"),
      ToDate: day.date.strftime("%Y-%m-%d"),
      sortDirection: "asc",
      sortOrder: "Dokumentdatum",
      p: page,
    }
  end

  def url(page = 1)
    query = parameters(page).to_query
    url = "#{ENV["WORK_ENVIRONMENT_URL"]}?#{query}"
  end

  def result_count
    if hit_count == "Det finns inga filtreringsval för detta sökresultat" then
      return 0
    end
    if hit_count.nil? then
      return nil
    end
    matches = hit_count.match(/(\d+) träffar/)
    if !matches.nil? then
      return matches[1].to_i
    end
    matches = hit_count.match(/\A\d+\z/)
    if !matches.nil? then
      return matches.to_i
    end
    return hit_count
  end
end
