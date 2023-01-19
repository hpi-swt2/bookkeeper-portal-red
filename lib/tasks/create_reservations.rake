desc "For each item that has no active reservation, check if there is a waiting position. " \
     "If so, create a reservation for the user."

task create_reservations: :environment do
  Item.find_each(&:create_reservation_from_waitlist)
end
