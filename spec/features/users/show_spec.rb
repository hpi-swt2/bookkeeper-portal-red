require "rails_helper"

describe "User Profile Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }
  let(:user2) { FactoryBot.create(:user, password: password, full_name: "#{user.full_name}_other") }

  it "should list the user's full name" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.full_name)
  end

  it "should list the user's email" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.email)
  end

  it "should list the user's description" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.description)
  end

  it "should show profiles of other users" do
    sign_in user
    visit profile_path(user2.id)
    expect(page).to have_text(user2.full_name)
  end
end
