class AddMaxReservationDays < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :max_reservation_days, :integer, null: false, default: 1
  end
end
