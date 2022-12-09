class Permission < ApplicationRecord
  belongs_to :item
  belongs_to :group
  enum :permission_type, can_view: 0, can_borrow: 1, can_manage: 2
  def self.borrowers_of_item(item_id)
    groups = []
    i = 0
    Permission.all.each do |permission|
      puts(permission)
      if permission.item_id = :item_id && permission.permission_type = 'can_borrow'
        groups[i] = permission.group_id
        puts(permission.group_id)
        i = i + 1
      end
    return groups
    end
  end
end
