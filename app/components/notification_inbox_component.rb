# frozen_string_literal: true

class NotificationInboxComponent < ViewComponent::Base

  def initialize(user_id)
    super
    @notifications = Notification.where(display: true, user_id: user_id).order(:sent).last(30)
  end

end
