class Notification < ApplicationRecord
  belongs_to :user
  enum :notification_type, %i[reminder info warning error]
end
