class Day < ApplicationRecord
  has_many :searches

  scope :today, -> { where(date: Date.today) }
  scope :yesterday, -> { where(date: Date.yesterday) }

  enum ingestion_status: {
    ingestion_pending: 0,
    ingestion_active: 1,
    ingestion_complete: 2,
    ingestion_error: 3,
    ingestion_aborted: 4,
  }

  def next_page_number
    if searches.success.count == 0 then
      return 1
    end

    last_search = searches.result_ready.latest.first
    if last_search.results.count < 10 then
      return last_search.page_number
    end

    return last_search.page_number + 1
  end

  def looks_dormant?
    if date.strftime("%Y-%m-%d") == Date.today.strftime("%Y-%m-%d") then
      return false
    end

    if searches.count < 2 then
      return false
    end

    two_latest_searches = searches.success.retrospective(date).latest.take(2)
    if two_latest_searches.count < 2 then
      return false
    end

    same_page_number = two_latest_searches[0].page_number == two_latest_searches[1].page_number
    same_result_count = two_latest_searches[0].results.count == two_latest_searches[1].results.count
    no_new_results = same_page_number and same_result_count
    return no_new_results
  end
end
