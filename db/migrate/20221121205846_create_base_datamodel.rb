class CreateBaseDatamodel < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end

    create_table :memberships do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :group, null: false, foreign_key: true
      t.integer :role, null: false # enum, see Membership model

      t.timestamps
    end

    create_table :lendings do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.datetime :due_at

      t.timestamps
    end

    create_table :reservations do |t|
      t.belongs_to :item, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end

    add_column :items, :status, :integer, null: false, default: 0 # enum, see Item model (default: inactive)
    add_reference :items, :group, foreign_key: true 
  end
end
