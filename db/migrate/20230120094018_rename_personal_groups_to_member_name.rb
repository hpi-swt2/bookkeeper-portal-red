class RenamePersonalGroupsToMemberName < ActiveRecord::Migration[7.0]
  def change
    Group.where(tag: :personal_group).each do | group |
      group.name = group.memberships.first.user.full_name
      group.save!
    end
  end
end
