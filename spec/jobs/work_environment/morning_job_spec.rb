require "rails_helper"

describe WorkEnvironment::MorningJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  it "creates the week" do
    perform_enqueued_jobs { job.perform_now("2023-11-07", cascade: false) }
    expect(TimePeriod::Week.count).to eq(2)
    expect(TimePeriod::Week.last.week_code).to eq("2023-W45")
  end

  it "creates the day" do
    perform_enqueued_jobs { job.perform_now("2023-11-07", cascade: false) }
    expect(TimePeriod::Day.count).to eq(2)
    expect(TimePeriod::Day.last.ymd).to eq("2023-11-07")
  end

  it "queues the day job" do
    perform_enqueued_jobs(only: job) do
      job.perform_now("2023-11-07", cascade: true)
    end
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["job_class"]
    ).to eq("WorkEnvironment::DayJob")
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"].first[
        "value"
      ]
    ).to eq("2023-11-07")
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
