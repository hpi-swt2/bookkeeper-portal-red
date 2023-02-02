class NotificationMailer < ApplicationMailer
  default from: "bookkeeper.red@gmail.com"

  def test_notification
    mail(to: "bookkeeper.red@gmail.com", subject: "Test Bookkeeper") # rubocop:disable Rails/I18nLocaleTexts
  end

  # Yes, the instance variables are necessary here and yes we are aware of the code duplications
  def send_reminder(user, message_de, message_en, as_mail: true)
    @user = user
    @message_de = message_de
    @message_en = message_en
    create_notification(message_de, message_en, user, :reminder)
    mail(to: @user.email, subject: "Bookkeeper Red Reminder") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_info(user, message_de, message_en, as_mail: true)
    @user = user
    @message_de = message_de
    @message_en = message_en
    create_notification(message_de, message_en, user, :info)
    mail(to: @user.email, subject: 'Bookkeeper Red Info') if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  def send_alert(user, message_de, message_en, as_mail: true)
    @user = user
    @message_de = message_de
    @message_en = message_en
    create_notification(message_de, message_en, user, :alert)
    mail(to: @user.email, subject: "Bookkeeper Red Alert") if as_mail # rubocop:disable Rails/I18nLocaleTexts
  end

  private

  def create_notification(message_de, message_en, user, notification_type)
    notification = Notification.new
    notification.message = message_de
    notification.message_en = message_en
    notification.user_id = user.id
    notification.sent = Time.current
    notification.display = true
    notification.notification_type = notification_type

    notification.save
  end
end
