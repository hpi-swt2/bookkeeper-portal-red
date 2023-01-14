require "rails_helper"

describe "waitlist", type: :feature do
  let(:item) { FactoryBot.create(:item) }

  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }
  let(:user2) { FactoryBot.create(:user, password: password) }
  let(:user3) { FactoryBot.create(:user, password: password) }

  context "when user has borrowing rights" do
    before do
      group = FactoryBot.create(:group)
      FactoryBot.create(:membership, user: user, group: group)
      FactoryBot.create(:permission, item: item, group: group, permission_type: :can_borrow)
    end

    it "allows him to join the item waitlist if the item is currently reserved by another user" do
      FactoryBot.create(:reservation, item_id: item.id, user_id: user2.id, starts_at: Time.zone.now,
                                      ends_at: 2.days.from_now)

      sign_in user

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.join_waitlist')
      expect(page).not_to have_button I18n.t('items.buttons.leave_waitlist')

      # match: :first is needed because the mobile and web screen are rendered at the same time
      click_on I18n.t('items.buttons.join_waitlist'), match: :first
      expect(item.waitlist_has?(user)).to be true
      expect(item.allows_joining_waitlist?(user)).to be false
    end

    it "allows him to leave the item waitlist if he is already on it" do
      FactoryBot.create(:reservation, item_id: item.id, user_id: user2.id, starts_at: Time.zone.now,
                                      ends_at: 2.days.from_now)
      FactoryBot.create(:waiting_position, item_id: item.id, user_id: user.id)

      sign_in user

      visit item_path(item)
      expect(page).to have_button I18n.t('items.buttons.leave_waitlist')
      expect(page).not_to have_button I18n.t('items.buttons.join_waitlist')

      click_on I18n.t('items.buttons.leave_waitlist'), match: :first
      expect(item.waitlist_has?(user)).to be false
      expect(item.allows_joining_waitlist?(user)).to be true
    end

    it "does not allow him to join the item waitlist if the user already has his own reservation" do
      FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: Time.zone.now,
                                      ends_at: 2.days.from_now)
      sign_in user
      visit item_path(item)
      expect(page).not_to have_button I18n.t('items.buttons.join_waitlist')
    end

    it "does not allow him to join the item waitlist if the user already has his own lending" do
      # This first one is necessary to satisfy the waitlist condition that someone else needs to have a reservation:
      FactoryBot.create(:reservation, item_id: item.id, user_id: user2.id, starts_at: Time.zone.now,
                                      ends_at: 2.days.from_now)
      FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: Time.zone.now, completed_at: nil,
                                  due_at: 2.days.from_now)
      sign_in user
      visit item_path(item)
      expect(page).not_to have_button I18n.t('items.buttons.join_waitlist')
    end

    it "automatically creates a reservation for the user that holds the oldest waiting position when the item is returned and deletes the waiting position" do
      # User 2 has the oldest waiting position, user 3 the newest one:
      FactoryBot.create(:waiting_position, item_id: item.id, user_id: user2.id, created_at: 2.days.ago)
      FactoryBot.create(:waiting_position, item_id: item.id, user_id: user3.id, created_at: 1.day.ago)
      # Our user has currently borrowed the item:
      FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: Time.zone.now, completed_at: nil,
                                  due_at: 2.days.from_now)

      sign_in user
      visit "#{item_path(item)}?src=qrcode"
      click_on I18n.t('items.buttons.return'), match: :first

      # After our user returns the item, we expect that user 2 has converted his
      # waiting position to a reservation and user 3 still has his waiting position:
      expect(item.reserved_by?(user2)).to be true
      expect(item.waitlist_has?(user2)).to be false
      expect(item.waitlist_has?(user3)).to be true
    end
  end
end
