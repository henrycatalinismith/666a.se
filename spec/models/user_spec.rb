require "rails_helper"

describe User, :type => :model do

  let(:user) { User.create(
    id: "01hmf3mpq73axkw2h1ap55j52r",
    name: "Example User",
    company_code: "123456-1234",
    password: "hunter2",
    password_confirmation: "hunter2",
    email: "user@example.org",
  )}

  describe :admin? do
    it "returns false by default" do
      expect(user.admin?).to be false
    end

    it "returns true when the user has an admin role" do
      user.roles << Role.new(name: :admin)
      expect(user.admin?).to be true
    end
  end

end