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

  it "creates a notification object" do
    user = FactoryBot.build(:user)
    user.id = 1
    user.save

    expect { described_class.send_info(user, "Test").deliver_now }.to change(Notification, :count).by(1)
    expect(Notification.last.message).to eq("Test")
    expect(Notification.last.user_id).to eq(1)
    expect(Notification.last.notification_type).to eq("info")
    expect(Notification.last.display).to be(true)
    expect(Notification.last.sent).to be_within(5.seconds).of(Time.zone.now)
  end

  it "can authenticate with GMail" do
    skip("Mail credentials are not available") if ENV["MAIL_USERNAME"].blank? || ENV["MAIL_PASSWORD"].blank?
    smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'gmail.com',
      user_name: ENV.fetch("MAIL_USERNAME"),
      password: ENV.fetch("MAIL_PASSWORD"),
      authentication: 'plain',
      enable_starttls_auto: true,
      open_timeout: 5,
      read_timeout: 5
    }
    smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
    smtp.enable_starttls_auto if smtp_settings[:enable_starttls_auto] && smtp.respond_to?(:enable_starttls_auto)

    expect do
      smtp.start(smtp_settings[:domain], smtp_settings[:user_name],
                 smtp_settings[:password], smtp_settings[:authentication]) { {} }
    end.not_to raise_error
  end
end
