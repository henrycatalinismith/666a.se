require "rails_helper"

describe WorkEnvironment::DocumentJob do
  include ActiveJob::TestHelper

  subject(:job) { described_class }

  let(:metadata) { <<-TEXT }
{"Diarienummer":"2023/034601","Handlingsnummer":"2023/034601-24","Ärendemening":"Skyddsombuds begäran om ingripande enligt 6 kap 6a § arbetsmiljölagen - ventilation","Handlingstyp":"Underrättelse om föreläggande/förbud","Inkommande/Utgående":"Utgående","Organisation":"SVENSKA RÖDA KORSETS CENTRALSTYRELSE (802002-8711)","Arbetsställenummer (CFAR)":"11290723","Arbetsställe":"SVENSKA RÖDA KORSETS CENTRALSTYRELSE","Län":"STOCKHOLMS LÄN (01)","Kommun":"Stockholm (0180)","Datum":"2023-11-08","Pågående/Avslutat":"Pågående"}
TEXT

  let(:day) { time_period_day(:halloween) }

  let(:search) do
    WorkEnvironment::Search.new(
      day: day,
      result_status: :result_pending,
      page_number: 1
    )
  end

  let(:result) do
    WorkEnvironment::Result.new(
      search: search,
      document_code: "2023/034601-24",
      metadata: metadata
    )
  end

  let(:hunter2) { user(:hunter2) }

  let(:subscription) do
    WorkEnvironment::Subscription.new(
      id: "abcdef",
      subscription_type: :company_subscription,
      company_code: "802002-8711",
      user: hunter2
    )
  end

  it "creates the document" do
    result.save
    perform_enqueued_jobs(only: job) { job.perform_now("2023/034601-24") }
    document =
      WorkEnvironment::Document.find_by(document_code: "2023/034601-24")
    expect(document.company_code).to eq("802002-8711")
    expect(document.company_name).to eq("SVENSKA RÖDA KORSETS CENTRALSTYRELSE")
    expect(document.workplace_code).to eq("11290723")
    expect(document.workplace_name).to eq(
      "SVENSKA RÖDA KORSETS CENTRALSTYRELSE"
    )
  end

  it "sets needless notification status when subscriptions exist" do
    result.save
    perform_enqueued_jobs(only: job) { job.perform_now("2023/034601-24") }
    document =
      WorkEnvironment::Document.find_by(document_code: "2023/034601-24")
    expect(document.notification_status).to eq("notification_needless")
  end

  it "sets pending notification status when subscriptions exist" do
    result.save
    subscription.save
    perform_enqueued_jobs(only: job) { job.perform_now("2023/034601-24") }
    document =
      WorkEnvironment::Document.find_by(document_code: "2023/034601-24")
    expect(document.notification_status).to eq("notification_pending")
  end

  it "queues notification job when subscriptions exist" do
    result.save
    subscription.save
    perform_enqueued_jobs(only: job) do
      job.perform_now("2023/034601-24", notify: true)
    end
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["job_class"]
    ).to eq("WorkEnvironment::NotificationJob")
    expect(
      ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"].first
    ).to eq("2023/034601-24")
  end
end
