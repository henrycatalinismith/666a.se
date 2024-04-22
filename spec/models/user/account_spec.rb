require "rails_helper"

describe User::Account, type: :model do
  describe :admin? do
    it "returns false by default" do
      expect(user_account(:hunter2).admin?).to be false
    end

    it "returns true when the user has an admin role" do
      user_account(:hunter2).roles << User::Role.new(name: :admin)
      expect(user_account(:hunter2).admin?).to be true
    end
  end
end
