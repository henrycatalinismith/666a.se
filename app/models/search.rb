class Search < ApplicationRecord
  belongs_to :day
  has_many :results, dependent: :destroy

  enum status: {
    pending: 0,
    active: 1,
    success: 2,
    error: 3,
    aborted: 4,
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
