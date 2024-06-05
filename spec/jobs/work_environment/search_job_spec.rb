require "rails_helper"

describe WorkEnvironment::SearchJob do
  let(:day) { time_period_day(:"2023-11-06") }

  let(:response) do
    File.read("spec/fixtures/work_environment/search/2023-10-31-p1.html")
  end

  context "2023-10-31 page 1" do
    before do
      day.save

      ENV["WORK_ENVIRONMENT_URL"] = "https://example.org/search/"
      stub_request(
        :get,
        "https://example.org/search/?FromDate=2023-11-06&ToDate=2023-11-06&p=1&sortDirection=asc&sortOrder=Dokumentdatum"
      ).to_return(status: 200, body: response)
    end

    let(:search) { day.searches.first }

    # it "records the hit count" do
    #   WorkEnvironment::SearchJob.perform_now(day.date)
    #   expect(search.hit_count).to eq("908")
    # end

    context "results" do
      it "records the document code" do
        WorkEnvironment::SearchJob.perform_now(day.date)
        expect(WorkEnvironment::Document.order(created_at: :asc).first.as_json.except("id", "created_at", "updated_at")).to eq({
          "case_code" => "2023/062312",
          "case_date" => nil,
          "case_name" => "Inspektion 20231031 - omedelbart förbud att utföra byggnads- och anläggningsarbete där fallhöjden är två meter eller mer, Heinövägen 79, Öckerö",
          "case_status" => "case_ongoing",
          "company_code" => "556495-9665",
          "company_name" => "ÖCKERÖ FASTIGHETS AB",
          "county_code" => nil,
          "county_name" => nil,
          "document_code" => "2023/062312-5",
          "document_date" => "2023-10-31",
          "document_direction" => "document_outgoing",
          "document_type" => "Beslut om slutligt omedelbart förbud",
          "municipality_code" => nil,
          "municipality_name" => nil,
          "workplace_code" => "33070707",
          "workplace_name" => "ÖCKERÖ FASTIGHETS AB",
        })
      end
    end
  end
end
