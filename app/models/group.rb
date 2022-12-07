class Group < ApplicationRecord
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
end
