# the main association between users and groups
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group, dependent: :destroy
  validate do
    errors.add(:user, "personal group cannot have multiple users") if group.personal_group? && !group.users.empty?
  end
  validate on: :create do
    if user.exists_personal_group? && group.personal_group? && user.personal_group.id != group.id
      errors.add(:user,
                 "user cannot have multiple personal groups")
    end
  end
  before_destroy :validate_destroy
  enum :role, admin: 0, member: 1

  def validate_destroy
    return unless group.personal_group? && !destroyed_by_association

    errors.add(:user, "user cannot leave personal group")
    throw(:abort)
  end
end
