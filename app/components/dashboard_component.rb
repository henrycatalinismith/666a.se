class DashboardComponent < ViewComponent::Base
  def initialize(user:, subscriptions:, last_refresh:)
    @user = user
    @subscriptions = subscriptions
    @last_refresh = last_refresh
  end
end
