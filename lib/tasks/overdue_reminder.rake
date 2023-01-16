desc "Check for borrowed items that have been overdue for a day and send a reminder email (and notification) to the user"
task overdue_reminder: :environment do
  lendings = Lending.where(due_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day, completed_at: nil)
  lendings.each do |lending|
    item = Item.find(lending.item_id)
    user = User.find(lending.user_id)

    message_1 = "Das Item #{item.name} war gestern fällig. Bitte geben Sie es unverzüglich dem Besitzer zurück."
    message_2 = "The item #{item.name} was due yesterday. Please return it to the owner immediately."
    NotificationMailer.send_reminder(user, message_1, message_2: message_2).deliver_now
  end
end
