require 'rails_helper'

describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "can be created using a factory" do
    expect(user).to be_valid
  end

  it "has an email attribute" do
    expect(user.email).not_to be_blank
  end

  it "is able to access personal group" do
    p_group = user.personal_group
    expect(p_group.name).to eq(user.full_name)
    expect(user.exists_personal_group?).to be(true)
    expect(user.personal_group).to eq(p_group)
  end

  it "ensures personal group exists to access it" do
    user2 = FactoryBot.build(:user)
    expect(user2.exists_personal_group?).to be(false)
    expect { user2.personal_group }.to raise_error(StandardError)
  end

  it "cannot create multiple personal groups" do
    expect { user.create_personal_group }.to raise_error(StandardError)
  end

  it "cannot have multiple personal groups" do
    p_group = Group.create(name: "personal_group", tag: :personal_group)
    p_group_membership = Membership.create(group_id: p_group.id, user_id: user.id, role: :member)
    user.memberships.push(p_group_membership)
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "destroys the personal group when the user is destroyed" do
    p_group = user.personal_group
    p_group_id = p_group.id
    mem_id = Membership.where(group: p_group, user: user).first.id
    expect(Membership.exists?(mem_id)).to be(true)
    expect(user.destroy).not_to be(false)
    expect(Group.exists?(p_group_id)).to be(false)
    expect(Membership.exists?(mem_id)).to be(false)
  end

  it "doesn't destroy shared groups when the user is destroyed" do
    membership = FactoryBot.create(:membership)
    group_id = membership.group.id
    expect(membership.user.destroy).not_to be(false)
    expect(Group.exists?(group_id)).to be(true)
    expect(Membership.exists?(membership.id)).to be(false)
  end

  it "can view items when having borrow permissions" do
    item = FactoryBot.create(:item)
    item.borrower_groups << user.personal_group
    expect(user.can_view?(item)).to be(true)
  end

  it "can view items when having manage permissions" do
    item = FactoryBot.create(:item)
    item.manager_groups << user.personal_group
    expect(user.can_view?(item)).to be(true)
  end

  it "can borrow items when having manage permissions" do
    item = FactoryBot.create(:item)
    item.manager_groups << user.personal_group
    expect(user.can_borrow?(item)).to be(true)
  end

  it "cannot leave its personal group" do
    membership = Membership.where(group: user.personal_group).first
    expect(membership.destroy).to be(false)
    expect(Membership.exists?(membership.id)).to be(true)
    expect(Group.exists?(membership.group.id)).to be(true)
  end

end
