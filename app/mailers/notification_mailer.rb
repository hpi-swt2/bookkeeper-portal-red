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

  def return_reminder(item)
    # Example how it could work, once user model methods are implemented
    @item = item
    mail(to: '@item.lending.user.email', name: '@item.lending.user.name', subject: "{item.name} is overdue!") # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_notification(message, user, notification_type, as_mail: true)
    create_notification(message, user, notification_type)
    mail(to: user.email, subject: "Bookeeper Red Notification") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  private

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
