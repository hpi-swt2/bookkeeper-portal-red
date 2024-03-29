require 'rails_helper'

describe "Notification inbox", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }

  before do
    sign_in user
  end

  context 'with JS', driver: :selenium_chrome, js: true, ui: true do
    it "no longer shows a notification when it is dismissed" do
      Capybara.current_session.current_window.resize_to(1600, 900)
      NotificationMailer.send_info(user, "Test_2", "Test_2").deliver_now
      visit root_path
      page.find_by_id("notification-inbox-button").click
      expect(page.find_by_id('notification-inbox-container')).to have_selector('.notification-message')
      expect(page.find_by_id('notification-inbox-container')).to have_text("Test_2")
      a = page.find_by_id('notification-inbox-container')
      b = a.find(".notification-message")
      b.find_by_id('delete-notification-button-1').click # rubocop:disable Rails/DynamicFindBy

      sleep 0.5 # Waiting for JS to execute (not ideal, but works)

      expect(a).not_to have_text("Test_2")
      expect(Notification.last.display).to be(false)
    end
  end
end
