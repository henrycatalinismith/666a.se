class DashboardController < ApplicationController
  layout "internal"

  def index
    @user = current_user
    @subscriptions = @user.subscriptions.active
    puts @user.roles.count
    puts "========================" 
    puts "========================" 
    puts "========================" 
    puts "========================" 
    puts "========================" 
    puts "========================" 
    puts "========================" 
    puts "========================" 
    render(DashboardComponent.new(user: @user, subscriptions: @subscriptions, last_refresh: @last_refresh))
  end
end
