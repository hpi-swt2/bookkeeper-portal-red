# frozen_string_literal: true

class NotificationComponent < ViewComponent::Base
  def initialize(type:, date:, time:, message:)
    @type = type
    @date = date
    @time = time
    @message = message
  end

end
