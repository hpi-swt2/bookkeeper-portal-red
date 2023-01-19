desc "Create a everyone group and add membership for everybody"

task introduce_everyone_group: :environment do
    e_group = Group.where(tag: "everyone_group").first
    return unless e_group.nil?
    e_group = Group.create(name: "everyone", tag: "everyone_group")
    User.all.each do |user|
        Membership.create(group_id: e_group.id, user_id: user.id, role: :member)
    end
end