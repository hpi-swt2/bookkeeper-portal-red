require "rails_helper"

describe "User Profile Page", type: :feature do
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }
  let(:user2) { FactoryBot.create(:user, password: password, full_name: "#{user.full_name}_other") }

  it "lists the user's full name" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.full_name)
  end

  it "lists the user's email" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.email)
  end

  it "lists the user's description" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_text(user.description)
  end

  it "shows profiles of other users" do
    sign_in user
    visit profile_path(id: user2.id)
    expect(page).to have_text(user2.full_name)
  end

  it "includes a link to edit the description for the logged-in user" do
    sign_in user
    visit profiles_me_path

    expect(page).to have_link(href: edit_profile_path)
  end

  it "does not allow editing other user's descriptions" do
    sign_in user
    visit profile_path(id: user2.id)
    expect(page).not_to have_link(href: edit_profile_path)
  end

  it "inlcudes a link to show the analytics for the authorized user" do
    sign_in user
    visit profiles_me_path
    expect(page).to have_link(href: analytics_path)
  end
end
