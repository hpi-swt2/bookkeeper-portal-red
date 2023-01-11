class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  validate do
    errors.add(:user, "personal group cannot have multiple users") if group.personal_group? and !group.users.empty?
  end
  enum :role, admin: 0, member: 1
end
