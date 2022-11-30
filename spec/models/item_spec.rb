require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { FactoryBot.create(:item) }
  let(:user) { FactoryBot.create(:user) }

  it "can have multiple groups with different permissions" do
    group1 = FactoryBot.create(:group)
    group2 = FactoryBot.create(:group)
    group3 = FactoryBot.create(:group)

    item.permissions.create(group: group1, permission_type: :can_manage)
    item.permissions.create(group: group2, permission_type: :can_view)
    item.permissions.create(group: group3, permission_type: :can_lend)
    item.permissions.create(group: group3, permission_type: :can_view)

    expect(item.manager_groups.count).to eq(1)
    expect(item.manager_groups.first).to eq(group1)

    expect(item.viewer_groups.count).to eq(2)
    expect(item.viewer_groups.first).to eq(group2)
    expect(item.viewer_groups.second).to eq(group3)

    expect(item.lender_groups.count).to eq(1)
    expect(item.lender_groups.first).to eq(group3)
  end

  it "is able to determine if it is borrowed by the current user" do
    expect(item.borrowed_by?(user)).to be true
  end
end
