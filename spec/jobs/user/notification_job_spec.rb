require "rails_helper"

describe User::NotificationJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:day) { time_period_day(:halloween) }

  let(:search) do
    WorkEnvironment::Search.new(
      day: day,
      result_status: :result_pending,
      page_number: 1
    )
  end

  let(:hunter2) { user_account(:hunter2) }

  let(:subscription) do
    User::Subscription.new(
      id: "abcdef",
      subscription_type: :company_subscription,
      company_code: "802002-8711",
      account: hunter2
    )
  end

  let(:document) do
    WorkEnvironment::Document.new(
      document_code: "2023/034601-24",
      company_code: "802002-8711",
      company_name: "SVENSKA RÖDA KORSETS CENTRALSTYRELSE",
      workplace_code: "11290723",
      workplace_name: "SVENSKA RÖDA KORSETS CENTRALSTYRELSE",
    )
  end

  it "creates a notification with email_pending as the email_status" do
    subscription.save
    document.save
    perform_enqueued_jobs(only: job) { job.perform_now("2023/034601-24") }
    notification = User::Notification.first
    expect(notification.email_status).to eq("email_pending")
  end

  it "queues the email job" do
    subscription.save
    document.save
    perform_enqueued_jobs(only: job) do
      job.perform_now("2023/034601-24", cascade: true)
    end
    notification = User::Notification.first
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["job_class"]
    ).to eq("User::EmailJob")
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"].first
    ).to eq(notification.id)
  end
end
