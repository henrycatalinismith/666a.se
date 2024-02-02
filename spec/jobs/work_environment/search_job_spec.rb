require "rails_helper"

describe WorkEnvironment::SearchJob do
  let(:week) { TimePeriod::Week.new(week_code: "2023-W44") }

  let(:day) do
    TimePeriod::Day.new(
      week:,
      date: "2023-10-31",
      ingestion_status: :ingestion_pending
    )
  end

  let(:response) do
    File.read("spec/fixtures/work_environment/search/2023-10-31-p1.html")
  end

  context "2023-10-31 page 1" do
    before do
      day.save

      stub_request(
        :get,
        "https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?FromDate=2023-10-31&ToDate=2023-10-31&page=1&sortDirection=asc&sortOrder=Dokumentdatum"
      ).to_return(status: 200, body: response)

      WorkEnvironment::SearchJob.perform_now(day.date)
    end

    let(:search) { day.searches.first }
    let(:results) { search.results }

    it "records the hit count" do
      expect(search.hit_count).to eq("913 träffar")
    end

    context "results" do
      it "records the document code" do
        expect(results.first.document_code).to eq("2023/018014-1")
      end
    end
  end
end
