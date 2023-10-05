class DashboardController < ApplicationController
  layout "internal"

  def index
    @user = current_user
    @subscriptions = @user.subscriptions.active
    render(DashboardComponent.new(user: @user, subscriptions: @subscriptions, last_refresh: @last_refresh))
  end
end
