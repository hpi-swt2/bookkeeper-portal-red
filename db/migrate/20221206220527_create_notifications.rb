class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :notification_type
      t.string :message
      t.timestamp :sent
      t.boolean :display

      t.timestamps
    end
  end
end
