require 'rails_helper'

describe "Notification inbox", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }

  it "is empty when no notifications are present" do
    sign_in user
    visit root_path
    page.find_by_id("notification_inbox_button").click
    expect(page.find_by_id('notification-inbox-container')).to have_text("Notifications")
    expect(page.find_by_id('notification-inbox-container')).not_to have_selector('.notification-message')
  end

  it "shows a notification when one is present" do
    NotificationMailer.send_notification("Test", user, :info).deliver_now
    sign_in user
    visit root_path
    page.find_by_id("notification_inbox_button").click
    expect(page.find_by_id('notification-inbox-container')).to have_selector('.notification-message')
    expect(page.find_by_id('notification-inbox-container')).to have_text("Test")
  end

  # it "no longer shows a notification when it is dismissed" do
  #   NotificationMailer.send_notification("Test", user, :info).deliver_now
  #   sign_in user
  #   visit root_path
  #   page.find_by_id("notification_inbox_button").click
  #   expect(page.find_by_id('notification-inbox-container')).to have_selector('.notification-message')
  #   expect(page.find_by_id('notification-inbox-container')).to have_text("Test")
  #   page.find_by_id('notification-inbox-container')
  # .find(".notification-message").find('a', text: "notification-dismiss-button").click
  #   # expect(page.find_by_id('notification-inbox-container')
  # .find('.notification-message')).to have_css('display: none')
  #   expect(Notification.last.display).to eq(false)
  # end

end
