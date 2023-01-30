require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { FactoryBot.create(:group) }

  it "name is limited in length" do
    item = FactoryBot.build(:group, name: "a" * 51)
    expect(item).not_to be_valid
  end

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

  it "can be destroyed" do
    expect(group.destroy).not_to be(false)
  end

  context "when group is a personal_group" do
    it "cannot have two users" do
      user1 = FactoryBot.create(:user)
      pgroup1 = user1.personal_group
      user2 = FactoryBot.create(:user)
      expect do
        FactoryBot.create(:membership, user: user2, group: pgroup1)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "cannot be destroyed" do
      user1 = FactoryBot.create(:user)
      expect(user1.personal_group.destroy).to be(false)
    end
  end

end
