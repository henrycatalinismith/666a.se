require "rails_helper"

describe WorkEnvironment::Subscription, :type => :model do
  let(:user) { User.new(
    id: "01hmf3mpq73axkw2h1ap55j52r",
    name: "Example User",
    company_code: "123456-1234",
    password: "hunter2",
    password_confirmation: "hunter2",
    email: "user@example.org",
  )}

  it "is invalid with invalid company_code" do
    expect(WorkEnvironment::Subscription.new(company_code: "lol", user:)).to be_invalid
  end

  it "is valid with valid company_code" do
    expect(WorkEnvironment::Subscription.new(company_code: "123456-1234", user:)).to be_valid
  end

  it "is invalid with invalid workplace_code" do
    expect(WorkEnvironment::Subscription.new(workplace_code: "lol", user:)).to be_invalid
  end

  it "is valid with valid workplace_code" do
    expect(WorkEnvironment::Subscription.new(workplace_code: "12345678", user:)).to be_valid
  end

  describe("#has_notification?") do
    it "returns true if notification exists" do
      document = WorkEnvironment::Document.create!(
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
        notification_status: :notification_pending,
      )
      subscription = WorkEnvironment::Subscription.create!(user: user)
      notification = WorkEnvironment::Notification.create!(
        document_id: document.id,
        subscription_id: subscription.id,
        email_status: "email_pending",
      )
      expect(subscription.has_notification?(document.id)).to be true
    end

    it "returns false if notification does not exist" do
      document = WorkEnvironment::Document.create!(
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
        notification_status: :notification_pending,
      )
      subscription = WorkEnvironment::Subscription.create!(user: user)
      notification = WorkEnvironment::Notification.create!(
        document_id: document.id,
        subscription_id: subscription.id,
        email_status: "email_pending",
      )
      expect(subscription.has_notification?("2022/092923-1")).to be false
    end
  end
end