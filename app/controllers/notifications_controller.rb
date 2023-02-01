class NotificationsController < ActionController::API
  include ActionController::MimeResponds

  def all
    visible_notifications = Notification.where(
      display: true,
      user_id: current_user.id
    ).order(:sent).last(30)

    respond_to do |format|
      format.json { render json: visible_notifications }
    end
  end

  def destroy
    notification = Notification.find(params["id"])

    # Allow modifications only on notifications a user owns
    return unless notification.user_id == current_user.id

    # Don't delete the notification,
    # to keep track of all notifications ever sent to a user.
    # Just remove visibility for the notification.
    notification.display = false
    notification.save
  end
end
