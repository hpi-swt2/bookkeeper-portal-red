class RemoveMaxBorrowingPeriodFromItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :max_borrowing_period, :datetime
  end
end
