require 'rails_helper'

RSpec.describe "borrowed items", type: :feature do
  let(:password) { 'password' }
  let(:user1) { FactoryBot.create(:user, password: password) }
  let(:user2) { FactoryBot.create(:user, password: password) }

  before do
    # create some items
    item1 = FactoryBot.create(:item, name: 'Item 1')
    item2 = FactoryBot.create(:item, name: 'Item 2')
    item3 = FactoryBot.create(:item, name: 'Item 3')

    # create two groups
    group1 = FactoryBot.create(:group)
    group2 = FactoryBot.create(:group)

    # assign user1 to group1 and user2 to group2
    Membership.create(user: user1, group: group1, role: 1)
    Membership.create(user: user2, group: group2, role: 1)

    # item1 and item2 are managed by group1 (user1)
    item1.manager_groups << group1
    item2.manager_groups << group1

    # item3 is managed by group2 (user2)
    item3.manager_groups << group2

    # item2 is borrowed by user2
    # item3 is borrowed by user1
    now = Time.zone.now
    Lending.create(item: item2, user: user2, started_at: now, due_at: now + 10.days, created_at: now)
    Lending.create(item: item3, user: user1, started_at: now, due_at: now + 10.days, created_at: now)
  end

  it "shows my items that are borrowed" do
    sign_in user1
    visit my_borrowed_items_path

    expect(page).not_to have_text "Item 1"
    expect(page).to have_text "Item 2"
    expect(page).not_to have_text "Item 3"
  end

  it "shows items that i've borrowed" do
    sign_in user1
    visit borrowed_items_path

    expect(page).not_to have_text "Item 1"
    expect(page).not_to have_text "Item 2"
    expect(page).to have_text "Item 3"
  end
end
