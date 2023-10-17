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

  def refresh
    @subscription = Subscription.find_by_id(params[:id])
    date = Time.now.strftime("%F")
    #SubscriptionRefreshJob.perform_later(@subscription, "2023-08-30")
    SubscriptionRefreshJob.perform_later(@subscription, "2023-05-09")
    redirect_to "/dashboard", :notice => "Queued"
  end
end
