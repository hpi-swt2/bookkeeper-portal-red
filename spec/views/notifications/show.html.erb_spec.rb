require 'rails_helper'

describe "Notification inbox", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }

  before do
    sign_in user
  end

  it "is empty when no notifications are present" do
    visit root_path
    page.find_by_id("notification-inbox-button").click
    expect(page.find_by_id('notification-inbox-container')).to have_text("Notifications")
    expect(page.find_by_id('notification-inbox-container')).not_to have_selector('.notification-message')
    expect(page.find_by_id('notification-inbox-container')).to have_text("You don't have any notifications yet. 🕵️")
  end

  it "shows a notification when one is present" do
    NotificationMailer.send_info("Test", user).deliver_now
    visit root_path
    page.find_by_id("notification-inbox-button").click
    expect(page.find_by_id('notification-inbox-container')).to have_selector('.notification-message')
    expect(page.find_by_id('notification-inbox-container')).to have_text("Test")
  end

end
