class Search < ApplicationRecord
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
end
