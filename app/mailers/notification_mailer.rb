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
    mail(to: "bookkeeper.red@gmail.com", subject: "Test Bookkeeper")
  end

  def return_reminder(item)
    # Example how it could work, once user model methods are implemented
    @item = item
    mail(to: '@item.lending.user.email',name: '@item.lending.user.name', subject: "{item.name} is overdue!")
  end

end
