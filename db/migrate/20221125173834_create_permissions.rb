class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :group, null: false, foreign_key: true
      t.integer :permission_type, null: false # enum, see Permission model

      t.timestamps
    end

    remove_column :items, :group_id, :integer
  end
end
