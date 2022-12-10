class AddLatLngToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :lat, :float
    add_column :items, :lng, :float
  end
end
