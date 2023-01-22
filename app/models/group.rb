# Model of the current group
class Group < ApplicationRecord
  enum tag: { verified_group: 0, personal_group: 1, everyone_group: 2 }
  validates :name, presence: true
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :permissions, dependent: :destroy
  has_many(
    :managed_items,
    -> { where(permissions: { permission_type: :can_manage }) },
    through: :permissions,
    source: :item
  )
  has_many(
    :viewable_items,
    -> { where(permissions: { permission_type: :can_view }) },
    through: :permissions,
    source: :item
  )
  has_many(
    :borrowable_items,
    -> { where(permissions: { permission_type: :can_borrow }) },
    through: :permissions,
    source: :item
  )

  def self.owner_groups(item_id)
    find_by_sql ["SELECT *
      FROM groups
      WHERE id IN (SELECT group_id FROM permissions WHERE item_id = :item_id AND permission_type = :permission_type)",
                 { item_id: item_id, permission_type: "2" }]
  end

  def user_count
    users.length
  end

  def as_json(options)
    super((options).merge({
      :methods => [:user_count]
    }))
  end

end
