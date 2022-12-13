class NotificationMailer < ApplicationMailer
  default from: "bookkeeper.red@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.test_notification.subject
  #
  def test_notification
    # @user = user
    # @book = book
    # mail(to: @user.email, subject: "New book added")
    mail(to: "bookkeeper.red@gmail.com", subject: "Test Bookkeeper") # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_notification(message, user, notification_type, as_mail: true)
    @user = user
    @message = message
    @notification_type = notification_type
    create_notification(message, user, notification_type)
    mail(to: @user.email, subject: "Bookkeeper Red Notification") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  def create_notification(message, user, notification_type)
    notification = Notification.new
    notification.message = message
    notification.user_id = user.id
    notification.sent = DateTime.now
    notification.display = true
    notification.notification_type = notification_type

    notification.save
  end
end
