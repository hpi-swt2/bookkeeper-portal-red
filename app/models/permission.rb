# Model of permissions for items
class Permission < ApplicationRecord
  belongs_to :item
  belongs_to :group
  enum :permission_type, can_view: 0, can_borrow: 1, can_manage: 2
  def self.borrowers_of_item(item_id)
    groups = []
    Permission.all.find_each do |permission|
      if permission.item_id == item_id && permission.permission_type == 'can_borrow'
        groups.append(permission.group_id.to_s)
      end
    end
    groups
  end

  def self.permission_for_group(group_id, item_id)
    Permission.all.find_each do |permission|
      return permission.permission_type if permission.item_id == item_id && permission.group_id == group_id
    end
  end
end
