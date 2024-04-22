require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "notify" do
    let(:hunter2) { user_account(:hunter2) }

    let(:document) do
      WorkEnvironment::Document.new(
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
    end

    let(:subscription) do
      User::Subscription.new(
        id: "abcdef",
        subscription_type: :company_subscription,
        company_code: "556595-9995",
        account: hunter2
      )
    end

    let(:notification) do
      User::Notification.new(
        document: document,
        subscription: subscription
      )
    end

    let(:mail) do
      described_class
        .with(notification: notification)
        .notification_email()
        .deliver_now
    end

    it "renders the headers" do
      expect(mail.subject).to eq("⛧ Document Alert")
      expect(mail.to).to eq(["user@example.org"])
      expect(mail.from).to eq(["henry@666a.se"])
    end

    it "includes the user's name" do
      expect(mail.body.encoded).to match("Hey Example User,")
    end

    it "mentions the company name for context" do
      expect(mail.body.encoded).to match(
        "You're subscribed to email updates for Work Environment Authority filings about HUSKOMPONENTER LINGHED AB."
      )
    end

    it "translates the document type to english" do
      expect(mail.body.encoded).to match(
        "2023/073482-1: Notification of accident"
      )
    end

    it "includes the unsubscribe url" do
      expect(mail.body.encoded).to match("https://666a.se/unsubscribe/abcdef")
    end
  end
end
