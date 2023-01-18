# rubocop:disable Rails/ReversibleMigration

class EveryoneGroup < ActiveRecord::Migration[7.0]
  def change
    execute "
      INSERT INTO groups(name, created_at, updated_at, tag) VALUES ('everyone', datetime(), datetime(), 2)
      "
  end
end
