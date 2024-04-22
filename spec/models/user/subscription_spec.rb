require "rails_helper"

describe User::Subscription, type: :model do
  let(:hunter2) { user_account(:hunter2) }

  it "is invalid with invalid company_code" do
    expect(
      User::Subscription.new(company_code: "lol", account: hunter2)
    ).to be_invalid
  end

  it "is valid with valid company_code" do
    expect(
      User::Subscription.new(
        company_code: "123456-1234",
        account: hunter2
      )
    ).to be_valid
  end

  it "is invalid with invalid workplace_code" do
    expect(
      User::Subscription.new(workplace_code: "lol", account: hunter2)
    ).to be_invalid
  end

  it "is valid with valid workplace_code" do
    expect(
      User::Subscription.new(
        workplace_code: "12345678",
        account: hunter2
      )
    ).to be_valid
  end

  describe("#has_notification?") do
    it "returns true if notification exists" do
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
      subscription = User::Subscription.create!(account: hunter2)
      notification =
        User::Notification.create!(
          document_id: document.id,
          subscription_id: subscription.id,
          email_status: "email_pending"
        )
      expect(subscription.has_notification?(document.id)).to be true
    end

    it "returns false if notification does not exist" do
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
      subscription = User::Subscription.create!(account: hunter2)
      notification =
        User::Notification.create!(
          document_id: document.id,
          subscription_id: subscription.id,
          email_status: "email_pending"
        )
      expect(subscription.has_notification?("2022/092923-1")).to be false
    end
  end
end
