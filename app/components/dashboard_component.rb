class DashboardComponent < ViewComponent::Base
  def initialize(user:, last_refresh:)
    @user = user
    @last_refresh = last_refresh
  end
end
