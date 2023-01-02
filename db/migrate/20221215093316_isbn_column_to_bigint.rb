class IsbnColumnToBigint < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:items, :isbn, nil)
    change_column(:items, :isbn, :bigint)
  end

  def down
    change_column_default(:items, :isbn, :bigint)
    change_column(:items, :isbn, :integer)
  end
end
