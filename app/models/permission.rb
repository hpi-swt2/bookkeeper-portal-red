class Permission < ApplicationRecord
  belongs_to :item
  belongs_to :group
  enum :permission_type, can_view: 0, can_borrow: 1, can_manage: 2
end
