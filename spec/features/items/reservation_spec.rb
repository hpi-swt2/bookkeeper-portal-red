require "rails_helper"

describe "show item page", type: :feature do
  let(:item) { FactoryBot.create(:item) }

  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }

  context "user has lending rights" do
    before(:each) do
      group = FactoryBot.create(:group)
      FactoryBot.create(:membership, user: user, group: group)
      FactoryBot.create(:permission, item: item, group: group, permission_type: :can_borrow)
    end

    it "should display a reservation button if the item is not borrowed nor reserved" do
      sign_in user
      
      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.reserve')
      expect(page).to have_text I18n.t('items.status_badge.available')

      # match: :first is needed because the mobile and web screen are rendered at the same time
      click_on I18n.t('items.buttons.reserve'), match: :first
      expect(item.reserved_by?(user)).to be true
      expect(item.borrowed_by?(user)).to be false

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.borrow')
      expect(page).to have_text I18n.t('items.status_badge.reserved_by_me')
    end

    it "should display a borrow button if the item is reserved by the user" do
      sign_in user
      FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: Time.zone.now, ends_at: Time.zone.now + 2.day)

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.borrow')
      expect(page).to have_text I18n.t('items.status_badge.reserved_by_me')

      click_on I18n.t('items.buttons.borrow'), match: :first
      expect(item.reserved_by?(user)).to be false
      expect(item.borrowed_by?(user)).to be true

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.return')
      expect(page).to have_text I18n.t('items.status_badge.borrowed_by_me')
    end

    it "should display a return button if the item is borrowed by the user" do
      sign_in user
      FactoryBot.create(:lending,item_id: item.id, user_id: user.id,started_at: Time.zone.now, completed_at: nil, due_at: Time.zone.now + 2.day)

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.return')
      expect(page).to have_text I18n.t('items.status_badge.borrowed_by_me')

      click_on I18n.t('items.buttons.return'), match: :first
      expect(item.reserved_by?(user)).to be false
      expect(item.borrowed_by?(user)).to be false 

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.reserve')
      expect(page).to have_text I18n.t('items.status_badge.available') 
    end

  end
end
