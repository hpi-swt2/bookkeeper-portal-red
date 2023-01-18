class EveryoneGroup < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    execute "
      INSERT INTO groups(name, created_at, updated_at, tag) VALUES ('everyone', datetime(), datetime(), 2)
      "
    # rubocop:enable Rails/ReversibleMigration
  end
end
