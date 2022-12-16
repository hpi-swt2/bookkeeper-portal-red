# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/test_notification
  def test_notification
    NotificationMailer.test_notification
  end

  def return_reminder
    NotificationMailer.return_reminder(nil)
  end
end
