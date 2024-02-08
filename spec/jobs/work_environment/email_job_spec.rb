require "rails_helper"

describe WorkEnvironment::EmailJob do
  let(:hunter2) { user(:hunter2) }

  it "sends a notification email" do
    subscription =
      WorkEnvironment::Subscription.create!(
        id: "01hkpq6dn83pd1nmckxdr0wvhm",
        user_id: hunter2.id
      )
    document =
      WorkEnvironment::Document.create!(
        document_code: "2023/073482-1",
        document_date: "2023-12-01",
        document_direction: :document_incoming,
        document_type: "Anmälan om olycka",
        case_code: "2023/073482",
        case_name: "Olycksfall 20231213. Fallande/flygande föremål",
        case_status: :case_ongoing,
        company_code: "556595-9995",
        company_name: "HUSKOMPONENTER LINGHED AB",
        workplace_code: "39478045",
        workplace_name: "HUSKOMPONENTER LINGHED AB",
        county_code: "20",
        county_name: "DALARNAS LÄN",
        municipality_code: "2080",
        municipality_name: "Falun",
        notification_status: :notification_pending
      )
    notification =
      WorkEnvironment::Notification.create!(
        document_id: document.id,
        subscription_id: subscription.id,
        email_status: "email_pending"
      )

    mailer = double(:mailer)
    mail = double(:mail)
    expect(NotificationMailer).to receive(:with).and_return(mailer)
    expect(mailer).to receive(:notification_email).and_return(mail)
    expect(mail).to receive(:deliver_now)

    WorkEnvironment::EmailJob.perform_now(notification.id)

    expect { notification.reload }.to change(notification, :email_status).from(
      "email_pending"
    ).to("email_success")
  end
end
