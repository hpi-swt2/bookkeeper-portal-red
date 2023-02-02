require 'rails_helper'

describe "Notification inbox", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }

  context 'with JS', driver: :selenium_chrome, js: true, ui: true do

    before do
      sign_in user
    end

    it "is empty when no notifications are present" do
      visit root_path
      page.find_by_id("notification-inbox-button").click
      expect(page.find_by_id('notification-inbox-container')).to have_text(I18n.t("navbar.notifications.headline"))
      expect(page.find_by_id('notification-inbox-container')).not_to have_selector('.notification-message')
      expect(page.find_by_id('notification-inbox-container')).to have_text(I18n.t("navbar.notifications.emptyInbox"))
    end

    it "shows a notification when one is present" do
      NotificationMailer.send_info(user, "Test", "Test").deliver_now
      visit root_path
      page.find_by_id("notification-inbox-button").click
      expect(page.find_by_id('notification-inbox-container')).to have_selector('.notification-message')
      expect(page.find_by_id('notification-inbox-container')).to have_text("Test")
    end

  end

end
