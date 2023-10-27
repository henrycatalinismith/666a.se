class WorkEnvironment::Search < ApplicationRecord
  belongs_to :day
  has_many :results, dependent: :destroy

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

  def parameters
    {
      FromDate: day.date.strftime("%Y-%m-%d"),
      ToDate: day.date.strftime("%Y-%m-%d"),
      sortDirection: "asc",
      sortOrder: "Dokumentdatum",
      page: page_number,
    }
  end

  def url
    host = "www.av.se"
    path = "/om-oss/sok-i-arbetsmiljoverkets-diarium/"
    query = parameters.to_query
    "https://#{host}#{path}?#{query}"
  end

  def result_count
    if hit_count == "Det finns inga filtreringsval för detta sökresultat" then
      return 0
    end
    hit_count.match(/(\d+) träffar/)[1].to_i
  end
end