class SubscriptionsController < ApplicationController
  layout "internal"

  def new
    if request.post?
      @subscription = current_user.subscriptions.create(company_code: params[:subscription][:company_code])
      if @subscription.valid?
        redirect_to "/dashboard", :notice => "Subscription created"
      end
    else
      @subscription = Subscription.new
    end
  end

  def destroy
    @subscription = Subscription.find_by_id(params[:id])
    if @subscription.user_id != current_user.id then
      return
    end
    @subscription.destroy
    redirect_to "/dashboard", :notice => "Subscription deleted"
  end

  def unsubscribe
    @subscription = Subscription.find_by_id(params[:id])
    if @subscription.nil? then
      raise ActionController::RoutingError.new('Not Found')
    end
    if request.get? then
      @mode = :before
    elsif request.post? and @subscription.destroy! then
      @mode = :after
    end
  end
end
