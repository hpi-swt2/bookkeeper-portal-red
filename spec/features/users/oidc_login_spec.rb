require "rails_helper"

describe "OpenId Connect Login", type: :feature do
  context "with valid credentials" do
    before do
      OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
        provider: "openid_connect",
        uid: "123456789",
        info: {
          email: "test@test.com"
        }
      )

      visit new_user_session_path
      find_by_id('openid_connect-signin').click
    end

    it "redirects to root path" do
      expect(page).to have_current_path(root_path)
    end

    it "displays a success message" do
      expect(page).to have_css(".alert-success")
    end
  end

  context "with invalid credentials" do
    before do
      @omniauth_logger = OmniAuth.config.logger
      # Change OmniAuth logger (default output to STDOUT)
      OmniAuth.config.logger = Rails.logger

      OmniAuth.config.mock_auth[:openid_connect] = :invalid_credentials
      visit new_user_session_path
      find_by_id('openid_connect-signin').click
    end

    after(:all) do
      # Restore the original logger
      OmniAuth.config.logger = @omniauth_logger
    end

    it "redirects to root path" do
      expect(page).to have_current_path(root_path)
    end

    it "shows a danger flash message" do
      expect(page).to have_css(".alert-danger")
    end

  end
end
