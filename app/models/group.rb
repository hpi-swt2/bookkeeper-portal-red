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
  after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new -- see https://stackoverflow.com/questions/29575259/default-values-for-models-in-rails

  def set_defaults
    self.verified = true if verified.nil?
  end

  def display_name
    display = name.html_safe
    html_verified_icon = "<i class='bi bi-patch-check-fill text-warning'></i>"
    display << html_verified_icon.html_safe if verified
    display
  end
end
