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

  # Yes, the instance variables are necessary here and yes we are aware of the code duplications
  def send_reminder(message, user, as_mail: true)
    @user = user
    @message = message
    create_notification(message, user, :reminder)
    mail(to: @user.email, subject: "Bookkeeper Red Reminder") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_info(message, user, as_mail: true)
    @user = user
    @message = message
    create_notification(message, user, :info)
    mail(to: @user.email, subject: "Bookkeeper Red Info") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_alert(message, user, as_mail: true)
    @user = user
    @message = message
    create_notification(message, user, :alert)
    mail(to: @user.email, subject: "Bookkeeper Red Alert") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  private

  def create_notification(message, user, notification_type)
    notification = Notification.new
    notification.message = message
    notification.user_id = user.id
    notification.sent = Time.current
    notification.display = true
    notification.notification_type = notification_type

    notification.save
  end
end
