# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/test_notification
  def test_notification
    NotificationMailer.test_notification
  end

  def send_reminder
    user = FactoryBot.build(:user)
    user.id = 1
    NotificationMailer.send_reminder(user, "Dies könnte deine Test Nachricht sein", "This could be your test message!")
  end

  # rubocop:disable Metrics/MethodLength
  def inform_owners
    user = FactoryBot.build(:user)
    item = FactoryBot.build(:item)
    user.id = 1
    item_url = "https://bookkeeper-red.de/items/1"
    message_de = "Als Eigentümer des Artikels #{item.name} möchten wir Sie darüber informieren, dass " \
                 "#{user.full_name} ebendiesen Artikel reserviert hat. \n" \
                 "Sie können die Reservierung unter #{item_url} verwalten."
    message_en = "As owner of the item #{item.name} we would like to inform you that " \
                 "#{user.full_name} has reserved this item. \n" \
                 "You can manage the reservation under #{item_url}."

    NotificationMailer.send_info(user, message_de, message_en)
  end
  # rubocop:enable Metrics/MethodLength
end
