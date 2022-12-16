class IsbnIntToBigintChangeColumnType < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:items, :isbn, :bigint)
  end

  def down
    change_column_default(:items, :isbn, :integer)
  end
end
