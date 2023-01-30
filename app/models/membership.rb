# the main association between users and groups
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validate do
    errors.add(:user, "personal group cannot have multiple users") if group.personal_group? && !group.users.empty?
  end
  validate on: :create do
    errors.add(:user, "user cannot have multiple personal groups") if user.exists_personal_group? and group.personal_group? and user.personal_group.id != group.id
  end
  before_destroy :validate_destroy
  enum :role, admin: 0, member: 1

  def validate_destroy
    if group.personal_group? and not destroyed_by_association
      errors.add(:user, "user cannot leave personal group")
      throw(:abort)
    end
  end
end
