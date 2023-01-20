desc "Check for borrowed items that became overdue a multiple of weeks ago " \
     "and send a reminder email (and notification) to the user"
task weekly_overdue_reminder: :environment do
  Lending.all.each do |lending|
    time_diff = (Time.zone.now.to_date - lending.due_at.to_date).to_i

    next unless (time_diff % 7).zero? && time_diff.positive? && lending.completed_at.nil?

    item = Item.find(lending.item_id)
    user = User.find(lending.user_id)

    message1 = "Das Item '#{item.name}' war vor #{time_diff / 7} #{time_diff / 7 == 1 ? 'Woche' : 'Wochen'} fällig. " \
               "Bitte geben Sie es unverzüglich dem Besitzer zurück."
    message2 = "The item '#{item.name}' was due #{time_diff / 7} #{'week'.pluralize(time_diff / 7)} ago. " \
               "Please return it to the owner immediately."
    NotificationMailer.send_reminder(user, message1, message2: message2).deliver_now
  end
end
