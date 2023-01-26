class ChangeItemsDefaultStatus < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:items, :status, from: 0, to: 1)
  end

  def down
    change_column_default(:items, :status, from: 1, to: 0)
  end
end
