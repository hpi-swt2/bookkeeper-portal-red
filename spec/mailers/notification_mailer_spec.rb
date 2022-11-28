require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "test_notification" do
    let(:mail) { NotificationMailer.test_notification }

    it "renders the headers" do
      expect(mail.subject).to eq("Test notification")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
