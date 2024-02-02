require "rails_helper"

describe WorkEnvironment::MorningJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  it "creates the week" do
    perform_enqueued_jobs { job.perform_now("2023-10-31", cascade: false) }
    expect(TimePeriod::Week.count).to eq(1)
    expect(TimePeriod::Week.first.week_code).to eq("2023-W44")
  end

  it "creates the day" do
    perform_enqueued_jobs { job.perform_now("2023-10-31", cascade: false) }
    expect(TimePeriod::Day.count).to eq(1)
    expect(TimePeriod::Day.first.ymd).to eq("2023-10-31")
  end

  it "queues the day job" do
    perform_enqueued_jobs(only: job) do
      job.perform_now("2023-10-31", cascade: true)
    end
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["job_class"]
    ).to eq("WorkEnvironment::DayJob")
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"].first[
        "value"
      ]
    ).to eq("2023-10-31")
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
