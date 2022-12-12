class IsbnIntToBigintChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column(:items, :isbn, :bigint)
  end
end
