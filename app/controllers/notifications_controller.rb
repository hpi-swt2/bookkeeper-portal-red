class NotificationsController < ActionController::API
  def destroy
    @notification = Notification.find(params["id"])

    return unless @notification.user_id == current_user.id

    # Don't delete the notification,
    # to keep track of all notifications ever sent to a user.
    # Just remove visibility for the notification.
    @notification.display = false
    @notification.save
  end
end
