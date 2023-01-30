class GamePropertiesToString < ActiveRecord::Migration[7.0]
  def up
    change_column :items, :number_of_players, :string
    change_column :items, :playing_time, :string
  end

  def down
    change_column :items, :number_of_players, :integer
    change_column :items, :playing_time, :integer
  end
end
