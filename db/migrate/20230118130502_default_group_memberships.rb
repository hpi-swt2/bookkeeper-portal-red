class DefaultGroupMemberships < ActiveRecord::Migration[7.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    execute "
      INSERT INTO memberships(user_id, group_id, role, created_at, updated_at)
      SELECT users.id,
             (SELECT groups.id FROM groups WHERE groups.tag = 1 LIMIT 1),
             1,
             datetime(),
             datetime()
      FROM users;
    "
    # rubocop:enable Rails/ReversibleMigration
  end
end
