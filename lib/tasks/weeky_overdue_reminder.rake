desc "Check for borrowed items that became overdue a multiple of weeks ago and send a reminder email (and notification) to the user"
task weekly_overdue_reminder: :environment do
  Lending.all.each do |lending|
    time_diff = (Date.today - lending.due_at.to_date).to_i
    
    if time_diff % 7 == 0 && lending.completed_at.nil?
      item = Item.find(lending.item_id)
      user = User.find(lending.user_id)

      message_1 = "Das Item #{item.name} war vor #{time_diff / 7} Wochen fällig. Bitte geben Sie es unverzüglich dem Besitzer zurück."
      message_2 = "The item #{item.name} was due #{time_diff / 7} weeks ago. Please return it to the owner immediately."
      NotificationMailer.send_reminder(user, message_1, message_2: message_2).deliver_now
    end
  end
end
