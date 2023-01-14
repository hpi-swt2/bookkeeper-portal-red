require 'rails_helper'

RSpec.describe "my items", type: :feature do
  let(:password) { 'password' }
  let(:user1) { FactoryBot.create(:user, password: password) }

  before do
    # create an item
    @item1 = FactoryBot.create(:item, name: 'Item 1')

    # create a group
    @group1 = FactoryBot.create(:group)

    # assign user1 to group1
    Membership.create(user: user1, group: @group1, role: 1)

    # item1 is managed by group1 (user1)
    @item1.manager_groups << @group1
  end

  it "shows my items" do
    sign_in user1
    visit my_items_path

    expect(page).to have_text "Item 1"
    expect(page).not_to have_text "Item 2"
  end

  it "has matching status badges for an item" do
    sign_in user1
    visit my_items_path

    # item1 has 'no-access' status badge when user1 has no permissions
    expect(page).to have_text(:visible, I18n.t("items.status_badge.no_access"))

    # item1 has 'available' status badge after user1 gets permission
    FactoryBot.create(:permission, group: @group1, item: @item1, permission_type: :can_borrow)
    visit my_items_path
    expect(page).to have_text(:visible, I18n.t("items.status_badge.available"))

    # item1 has 'reserved-by-me' status badge when user1 reserves it
    FactoryBot.create(:reservation, item_id: @item1.id, user_id: user1.id, starts_at: Time.zone.now,
                                    ends_at: 2.days.from_now)
    visit my_items_path
    expect(page).to have_text(:visible, I18n.t("items.status_badge.reserved_by_me"))
    @item1.cancel_reservation_for(user1)

    # item1 has 'borrowed-by-me' status badge when user1 borrows it
    Lending.create(item_id: @item1.id, user_id: user1.id, started_at: Time.zone.now, completed_at: nil,
                   due_at: 2.days.from_now)
    visit my_items_path
    expect(page).to have_text(:visible, I18n.t("items.status_badge.borrowed_by_me"))
  end
end
