class NotificationsController < ActionController::API
  def destroy
    @notification = Notification.find(params["id"])

    return unless @notification.user_id == current_user.id

    @notification.display = false
    @notification.save
  end
end