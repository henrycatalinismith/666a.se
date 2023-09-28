class NotificationsController < ApplicationController
  def email
    notification = Notification.find_by_id(params[:id])
    NotificationMailer.with(notification: notification).notification_email.deliver_later
    redirect_to "/dashboard", :notice => "Sent"
  end
end
