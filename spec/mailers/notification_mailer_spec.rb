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

end
