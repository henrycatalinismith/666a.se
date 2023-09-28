class SubscriptionsController < ApplicationController
  def refresh
    @subscription = Subscription.find_by_id(params[:id])
    date = Time.now.strftime("%F")
    RefreshSubscriptionJob.perform_later(@subscription, date)
    redirect_to "/dashboard", :notice => "Queued"
  end
end
