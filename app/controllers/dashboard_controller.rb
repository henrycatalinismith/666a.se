class DashboardController < ApplicationController
  def index
    @user = current_user
    @last_refresh = @user.subscriptions.first.refreshes.success.order(created_at: "desc").first
    render(DashboardComponent.new(user: @user, last_refresh: @last_refresh))
  end
end
