class CreateWaitingPositions < ActiveRecord::Migration[7.0]
  def change
    create_table :waiting_positions do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
