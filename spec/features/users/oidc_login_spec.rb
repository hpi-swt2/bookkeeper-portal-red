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

    it "is able to see the logout button" do
      expect(page).to have_css ".logout-button"
    end

    it "signs out the user when they click on the logout button" do
      find('.logout-button', match: :first).click
      expect(page).to have_current_path(new_user_session_path)
    end

    it "displays a confirmation message when the user successfully logs out" do
      find('.logout-button', match: :first).click
      expect(page).to have_css(".alert-success")
    end

    it "displays a success message" do
      expect(page).to have_css(".alert-success")
    end

    it "creates a personal group for the user" do
      user = User.first
      expect(user.personal_group).not_to be_nil
    end
  end

  context "with invalid credentials" do
    before do
      OmniAuth.config.mock_auth[:openid_connect] = :invalid_credentials
      visit new_user_session_path
      find_by_id('openid_connect-signin').click
    end

    it "redirects to root path" do
      expect(page).to have_current_path(root_path)
    end

    it "shows a danger flash message" do
      expect(page).to have_css(".alert-danger")
    end

  end
end
