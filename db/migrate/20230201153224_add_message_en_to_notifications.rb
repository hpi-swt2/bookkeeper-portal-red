class AddMessageEnToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :message_en, :string
  end
end
