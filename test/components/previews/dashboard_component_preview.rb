class DashboardComponentPreview < ViewComponent::Preview
  def default
    @user = User.new
    @subscription = Subscription.new(company_code: '000000-0000')
    @user.subscriptions << @subscription
    render(DashboardComponent.new(user: @user, last_refresh: nil))
  end
end