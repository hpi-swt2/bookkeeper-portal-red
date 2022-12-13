class Notification < ApplicationRecord
  belongs_to :user
  enum :notification_type, %w[reminder info warning error].index_by(&:to_sym)

  scope :visible, -> { where(display: true) }
end
