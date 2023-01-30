require "rails_helper"

describe "freeze", type: :feature do
  let(:item) { FactoryBot.create(:item) }

  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }

  context "when user has managing rights" do
    before do
      group = FactoryBot.create(:group)
      FactoryBot.create(:membership, user: user, group: group)
      FactoryBot.create(:permission, item: item, group: group, permission_type: :can_manage)
    end

    it "allows him to freeze the item" do
      sign_in user
      visit item_path(item)
      expect(item.active?).to be true
      expect(page).to have_button(I18n.t('items.buttons.freeze'))

      # match: :first is needed because the mobile and web screen are rendered at the same time
      click_button I18n.t('items.buttons.freeze'), match: :first
      item.reload

      expect(item.inactive?).to be true
      expect(page).to have_button(I18n.t('items.buttons.unfreeze'))
      expect(page).to have_content(I18n.t('items.status_badge.not_available'))
    end

    it "allows him to unfreeze the item" do
      item.toggle_status

      sign_in user
      visit item_path(item)
      expect(item.inactive?).to be true
      expect(page).to have_button(I18n.t('items.buttons.unfreeze'))

      # match: :first is needed because the mobile and web screen are rendered at the same time
      click_button I18n.t('items.buttons.unfreeze'), match: :first
      item.reload

      expect(item.active?).to be true
      expect(page).to have_button(I18n.t('items.buttons.freeze'))
      expect(page).to have_content(I18n.t('items.status_badge.available'))
    end
  end

  context "when user has only borrowing rights" do
    before do
      group = FactoryBot.create(:group)
      FactoryBot.create(:membership, user: user, group: group)
      FactoryBot.create(:permission, item: item, group: group, permission_type: :can_borrow)
    end

    it "does not allow him to freeze or unfreeze the item" do
      sign_in user
      visit item_path(item)
      expect(page).not_to have_button(I18n.t('items.buttons.freeze'))
      expect(page).not_to have_button(I18n.t('items.buttons.unfreeze'))
    end

    it "does not allow him to reserve item when item was frozen" do
      sign_in user
      visit item_path(item)
      expect(item.active?).to be true
      expect(page).to have_button(I18n.t('items.buttons.reserve'))

      item.toggle_status

      visit item_path(item)
      expect(page).not_to have_button(I18n.t('items.buttons.reserve'))
    end

    it "does not allow him to borrow item when item was frozen" do
      sign_in user
      visit "#{item_path(item)}?src=qrcode"
      expect(page).to have_button(I18n.t('items.buttons.borrow'))

      item.toggle_status

      visit "#{item_path(item)}?src=qrcode"
      expect(page).not_to have_button(I18n.t('items.buttons.borrow'))
    end

    it "cancels his reservation when item was frozen" do
      FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: Time.zone.now,
                                      ends_at: 2.days.from_now)

      sign_in user
      visit item_path(item)
      expect(item.reserved_by?(user)).to be true

      item.toggle_status

      expect(item.reserved?).to be false
      expect(item.reserved_by?(user)).to be false
    end

    it "allows him to return the item when item was frozen" do
      FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: Time.zone.now, completed_at: nil,
                                  due_at: 2.days.from_now)

      sign_in user
      visit "#{item_path(item)}?src=qrcode"
      expect(page).to have_button(I18n.t('items.buttons.return'))

      item.toggle_status

      visit "#{item_path(item)}?src=qrcode"
      expect(page).to have_button(I18n.t('items.buttons.return'))
    end

    it "starts his reservation after unfreezing the item if he's the first on the waitlist" do
      FactoryBot.create(:waiting_position, item_id: item.id, user_id: user.id, created_at: 2.days.ago)
      item.inactive!

      expect(item.waitlist_has?(user)).to be true
      expect(item.reserved?).to be false

      item.toggle_status

      expect(item.reserved?).to be true
      expect(item.reserved_by?(user)).to be true
      expect(item.waitlist_has?(user)).to be false
    end
  end
end
