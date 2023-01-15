class SetDefaultMaxBorrowingDays < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:items, :max_borrowing_days, from: nil, to: 1)
    change_column_null(:items, :max_borrowing_days, false)
    change_column(:items, :isbn, :bigint)
  end

  def down
    change_column_default(:items, :max_borrowing_days, from: 1, to: nil)
    change_column_null(:items, :max_borrowing_days, true)
    change_column(:items, :isbn, :integer)
  end
end
