require 'rails_helper'

describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it "can be created using a factory" do
    expect(user).to be_valid
  end

  it "has an email attribute" do
    expect(user.email).not_to be_blank
  end

  it "is able to access personal group" do
    p_group = user.create_personal_group
    expect(p_group.name).to eq(user.full_name)
    expect(user.exists_personal_group?).to be(true)
    expect(user.personal_group).to eq(p_group)
  end

  it "ensures personal group exists to access it" do
    expect(user.exists_personal_group?).to be(false)
    expect { user.personal_group }.to raise_error(StandardError)
  end

  it "cannot create multiple personal groups" do
    user.create_personal_group
    expect { user.create_personal_group }.to raise_error(StandardError)
  end

  it "throws error if there are multiple personal groups" do
    user.create_personal_group
    p_group = Group.create(name: "personal_group", tag: :personal_group)
    p_group_membership = Membership.create(group_id: p_group.id, user_id: user.id, role: :member)
    user.memberships.push(p_group_membership)
    user.save
    expect { user.exists_personal_group? }.to raise_error(StandardError)
    expect { user.personal_group }.to raise_error(StandardError)
  end

  it "is destroyed when user is destroyed" do
    p_group = user.create_personal_group
    p_group_id = p_group.id
    user.destroy
    expect(Group.exists?(p_group_id)).to be(false)
  end

  it "can view items when having borrow permissions" do
    item = FactoryBot.create(:item)
    user.create_personal_group
    item.borrower_groups << user.personal_group
    expect(user.can_view?(item)).to be(true)
  end

  it "can view items when having manage permissions" do
    item = FactoryBot.create(:item)
    user.create_personal_group
    item.manager_groups << user.personal_group
    expect(user.can_view?(item)).to be(true)
  end

  it "can borrow items when having manage permissions" do
    item = FactoryBot.create(:item)
    user.create_personal_group
    item.manager_groups << user.personal_group
    expect(user.can_borrow?(item)).to be(true)
  end

end
