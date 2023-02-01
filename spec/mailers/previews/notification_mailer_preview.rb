# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/test_notification
  def test_notification
    NotificationMailer.test_notification
  end

  def send_reminder
    user = FactoryBot.build(:user)
    user.id = 1
    NotificationMailer.send_reminder(user, "Dies könnte deine Test Nachricht sein","This could be your test message!")
  end
end
