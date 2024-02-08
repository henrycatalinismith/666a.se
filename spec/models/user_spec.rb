require "rails_helper"

describe User, type: :model do
  describe :admin? do
    it "returns false by default" do
      expect(user(:hunter2).admin?).to be false
    end

    it "returns true when the user has an admin role" do
      user(:hunter2).roles << Role.new(name: :admin)
      expect(user(:hunter2).admin?).to be true
    end
  end
end
