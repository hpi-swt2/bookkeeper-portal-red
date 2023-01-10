class AddTagToGroup < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :tag, :integer
  end
end
