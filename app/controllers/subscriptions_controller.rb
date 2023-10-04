class SubscriptionsController < ApplicationController
  def destroy
    @subscription = Subscription.find_by_id(params[:id])
    if @subscription.user_id != current_user.id then
      return
    end
    # @subscription.destroy
    redirect_to "/dashboard", :notice => "Subscription deleted"
  end

  def refresh
    @subscription = Subscription.find_by_id(params[:id])
    date = Time.now.strftime("%F")
    RefreshSubscriptionJob.perform_later(@subscription, "2023-08-30")
    redirect_to "/dashboard", :notice => "Queued"
  end
end
