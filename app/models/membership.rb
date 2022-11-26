class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum :role, admin: 0, member: 1
end
