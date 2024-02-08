require "rails_helper"

describe WorkEnvironment::SearchJob do
  let(:day) { time_period_day(:halloween) }

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
        expect(results.map(&:document_code).sort).to eq(
          %w[
            2023/016154-5
            2023/018014-1
            2023/025193-1
            2023/035166-3
            2023/035515-2
            2023/036093-1
            2023/042874-1
            2023/044443-6
            2023/045809-3
            2023/051960-1
          ]
        )
      end
    end
  end
end
