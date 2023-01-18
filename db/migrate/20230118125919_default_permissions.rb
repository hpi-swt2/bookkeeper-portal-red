class DefaultPermissions < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    execute "
      INSERT INTO permissions(item_id, group_id, permission_type, created_at, updated_at)
      SELECT id, (
          SELECT groups.id
          FROM groups
          WHERE groups.tag = 1
          LIMIT 1),
          0,
          datetime(),
          datetime()
      FROM items;
      "
    # rubocop:enable Rails/ReversibleMigration
  end
end

