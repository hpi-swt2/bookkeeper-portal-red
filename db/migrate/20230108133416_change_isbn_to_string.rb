class ChangeIsbnToString < ActiveRecord::Migration[7.0]
  def up
    change_column :items, :isbn, :string
  end

  def down
    change_column :items, :isbn, :bigint
  end
end
