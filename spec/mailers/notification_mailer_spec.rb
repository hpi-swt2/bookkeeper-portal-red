require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "test_notification" do
    let(:mail) { described_class.test_notification }

    it "renders the headers" do
      expect(mail.subject).to eq("Test Bookkeeper")
      expect(mail.to).to eq(["bookkeeper.red@gmail.com"])
      expect(mail.from).to eq(["bookkeeper.red@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi, find me in app/views/notification_mailer/test_notification.html.erb")
    end
  end

  # it "can connect to and authenticate with gmail" do
  #   expect { described_class.test_notification.deliver_now }.not_to raise_error
  # end

  it "creates a notification object" do
    user = FactoryBot.build(:user)
    user.id = 1
    user.save

    expect { described_class.send_info("Test", user).deliver_now }.to change(Notification, :count).by(1)
    expect(Notification.last.message).to eq("Test")
    expect(Notification.last.user_id).to eq(1)
    expect(Notification.last.notification_type).to eq("info")
    expect(Notification.last.display).to be(true)
    expect(Notification.last.sent).to be_within(5.seconds).of(Time.zone.now)
  end
end
