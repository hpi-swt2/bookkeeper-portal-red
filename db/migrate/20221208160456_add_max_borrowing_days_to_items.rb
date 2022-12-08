class AddMaxBorrowingDaysToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :max_borrowing_days, :integer
  end
end
