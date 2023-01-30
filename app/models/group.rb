# Model of the current group
class Group < ApplicationRecord
  enum tag: { verified_group: 0, personal_group: 1, everyone_group: 2 }
  validates :name, presence: true
  #has to be delete_all instead of destroy in order to avoid cyclical dependent destroy via membership (which has dependent: :destroy on its group)
  has_many :memberships, dependent: :delete_all
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
  before_destroy :validate_destroy

  def self.owner_groups(item_id)
    find_by_sql ["SELECT *
      FROM groups
      WHERE id IN (SELECT group_id FROM permissions WHERE item_id = :item_id AND permission_type = :permission_type)",
                 { item_id: item_id, permission_type: "2" }]
  end

  def validate_destroy
    puts "Trying to delete me, eh? #{!!destroyed_by_association} #{!!personal_group?}"
    if personal_group? and !!destroyed_by_association
      puts "I AM RESPONSIBLE"
      errors.add(:group, "personal group cannot be destroyed #{destroyed_by_association}")
      throw(:abort)
    end
    if not personal_group? and destroyed_by_association
      puts "I 2 AM RESPONSIBLE  #{destroyed_by_association}"
      errors.add(:group, "shared groups cant be destroyed by association #{destroyed_by_association}")
      throw(:abort)
    end
  end
end
