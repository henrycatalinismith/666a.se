require "rails_helper"

describe WorkEnvironment::ResultJob do
  let(:day) { time_period_day(:halloween) }

  let(:search) do
    WorkEnvironment::Search.new(
      day: day,
      result_status: :result_pending,
      page_number: 1
    )
  end

  let(:result) do
    WorkEnvironment::Result.new(search: search, document_code: "2023/018014-1")
  end

  let(:response) do
    File.read("spec/fixtures/work_environment/result/2023-018014-1.html")
  end

  it "performs the job" do
    search.save
    result.save

    stub_request(
      :get,
      "https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=2023%2F018014-1"
    ).to_return(status: 200, body: response)

    WorkEnvironment::ResultJob.perform_now(result.document_code)

    result.reload

    expect(result.case_code).to eq("2023/018014")
    expect(result.case_date).to eq("2023-03-23")
    expect(result.case_status).to eq(:case_concluded)
    expect(result.company_code).to eq(nil)
    expect(result.company_name).to eq(nil)
    expect(result.workplace_code).to eq(nil)
    expect(result.workplace_name).to eq(nil)
    expect(result.county_code).to eq(nil)
    expect(result.county_name).to eq(nil)
    expect(result.municipality_code).to eq(nil)
    expect(result.municipality_name).to eq(nil)
  end
end
