class AddProfileAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string, null: false, default: ""
    add_column :users, :description, :string, null: false, default: ""
  end
end
