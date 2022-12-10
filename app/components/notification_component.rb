# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  def initialize(notification_record)
    super
    @id = notification_record.id
    @type = notification_record.notification_type || 'Reminder'
    @date = notification_record.sent.strftime('%D')
    @time = notification_record.sent.strftime('%I:%M %p')
    @message = notification_record.message
  end
end
