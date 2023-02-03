desc "Check for borrowed items that will be due tomorrow and send a reminder email to the user"
task return_reminder: :environment do
  lendings = Lending.where(due_at: Date.tomorrow.all_day, completed_at: nil)
  lendings.each do |lending|
    item = Item.find(lending.item_id)
    user = User.find(lending.user_id)

    message1 = "Das Item '#{item.name}' ist morgen fällig. Bitte geben Sie es dem Besitzer zurück."
    message2 = "The item '#{item.name}' is due tomorrow. Please return it to the owner."
    NotificationMailer.send_reminder(user, message1, message2).deliver_now
  end
end
