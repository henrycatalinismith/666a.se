class WorkEnvironment::SubscriptionsController < ApplicationController
  layout "internal"

  def new
    if request.post?
      company_code = params[:subscription][:company_code]
      subscription_props = {}
      if company_code.match(/\A\d{8}\z/) then
        subscription_props[:subscription_type] = :workplace_subscription
        subscription_props[:workplace_code] = company_code
      else
        subscription_props[:subscription_type] = :company_subscription
        subscription_props[:company_code] = company_code
      end
      @subscription = current_user.subscriptions.create(subscription_props)
      if @subscription.valid?
        redirect_to "/dashboard", :notice => "Subscription created"
      end
    else
      @subscription = User::Subscription.new
    end
  end

  def destroy
    @subscription = User::Subscription.find_by_id(params[:id])
    if @subscription.account_id != current_user.id then
      return
    end
    @subscription.destroy
    redirect_to "/dashboard", :notice => "Subscription deleted"
  end

  def unsubscribe
    @subscription = User::Subscription.find_by_id(params[:id])
    if @subscription.nil? then
      raise ActionController::RoutingError.new("Not Found")
    end
    if request.get? then
      @mode = :before
    elsif request.post? and @subscription.destroy! then
      @mode = :after
    end
  end
end