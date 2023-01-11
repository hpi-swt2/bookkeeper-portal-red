require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { FactoryBot.create(:group) }
  let(:personal_group) { FactoryBot.create(:group, tag: :personal_group) }

  it "can have multiple items with different permissions" do
    item1 = FactoryBot.create(:item)
    item2 = FactoryBot.create(:item)
    item3 = FactoryBot.create(:item)

    group.permissions.create(item: item1, permission_type: :can_manage)
    group.permissions.create(item: item2, permission_type: :can_view)
    group.permissions.create(item: item3, permission_type: :can_borrow)
    group.permissions.create(item: item3, permission_type: :can_view)

    expect(group.managed_items.count).to eq(1)
    expect(group.managed_items.first).to eq(item1)

    expect(group.viewable_items.count).to eq(2)
    expect(group.viewable_items.first).to eq(item2)
    expect(group.viewable_items.second).to eq(item3)

    expect(group.borrowable_items.count).to eq(1)
    expect(group.borrowable_items.first).to eq(item3)
  end

  context "when group is a personal_group" do
    let(:personal_group) { FactoryBot.create(:group, tag: :personal_group) }

    it "cannot have two users" do
      user1 = FactoryBot.create(:user)
      FactoryBot.create(:membership, user: user1, group: personal_group)
      user2 = FactoryBot.create(:user)
      expect do
        FactoryBot.create(:membership, user: user2, group: personal_group)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
