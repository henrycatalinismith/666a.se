require "rails_helper"

describe WorkEnvironment::DayJob do
  include ActiveJob::TestHelper

  fixtures :all
  subject(:job) { described_class }

  let(:day) { time_period_day(:halloween) }

  it "stops if the day looks dormant" do
    day.searches << WorkEnvironment::Search.new(
      result_status: :result_ready,
      page_number: 1
    )
    day.searches << WorkEnvironment::Search.new(
      result_status: :result_ready,
      page_number: 1
    )
    perform_enqueued_jobs(only: job) { job.perform_now("2023-10-31") }
  end

  it "stops at night" do
    Timecop.travel("2023-10-31 22:01")
    perform_enqueued_jobs(only: job) { job.perform_now("2023-10-31") }
    Timecop.return
  end

  it "runs itself every 30 seconds" do
    allow(job).to receive(:set).and_return(job)
    allow(job).to receive(:perform_later).and_return(job)
    perform_enqueued_jobs(only: job) { job.perform_now("2023-10-31") }
    expect(job).to have_received(:set).with(wait: 30.seconds)
    expect(job).to have_received(:perform_later).with(
      "2023-10-31",
      { force: false }
    )
  end

  it "runs the search job" do
    allow(job).to receive(:set).and_return(job)
    allow(job).to receive(:perform_later).and_return(job)
    perform_enqueued_jobs(only: job) do
      job.perform_now("2023-10-31", cascade: true)
    end
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["job_class"]
    ).to eq("WorkEnvironment::SearchJob")
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"].first[
        "value"
      ]
    ).to eq("2023-10-31")
  end
end
