class NotificationsController < ActionController::API

  def destroy
    @notification = Notification.find(params["id"])

    if @notification.user_id == current_user.id
      @notification.display = false
      @notification.save
    end

  end

end
