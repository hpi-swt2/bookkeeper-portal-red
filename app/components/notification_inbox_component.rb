# frozen_string_literal: true

class NotificationInboxComponent < ViewComponent::Base
  def initialize(user)
    super
    user_id = user.nil? ? nil : user.id
    @notifications = Notification.where(display: true, user_id: user_id).order(:sent).last(30)
  end
end
