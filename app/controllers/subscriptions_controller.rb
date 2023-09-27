class SubscriptionsController < ApplicationController
  def refresh
    @subscription = Subscription.find_by_id(params[:id])
    RefreshSubscriptionJob.perform_later(@subscription)
    redirect_to "/dashboard", :notice => "Queued"
  end
end
