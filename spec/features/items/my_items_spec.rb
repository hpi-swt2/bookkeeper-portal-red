require 'rails_helper'

RSpec.describe "my items", type: :feature do
  let(:password) { 'password' }
  let(:user1) { FactoryBot.create(:user, password: password) }

  before do
    # create an item
    item1 = FactoryBot.create(:item, name: 'Item 1')

    # create a group
    group1 = FactoryBot.create(:group)

    # assign user1 to group1
    Membership.create(user: user1, group: group1, role: 1)

    # item1 is managed by group1 (user1)
    item1.manager_groups << group1
  end

  it "shows my items" do
    sign_in user1
    visit my_items_path

    expect(page).to have_text "Item 1"
    expect(page).not_to have_text "Item 2"
  end
end
