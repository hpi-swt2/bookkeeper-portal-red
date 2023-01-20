desc "Create a everyone group and add membership for everybody"

task introduce_permission: :environment do
  e_group = Group.where(tag: "everyone_group").first

  Item.all.each do |item|
    unless Permission.exists?(item_id: item.id)
      Permission.create(group_id: e_group.id, permission_type: 1, item_id: item.id)
    end
  end
end
