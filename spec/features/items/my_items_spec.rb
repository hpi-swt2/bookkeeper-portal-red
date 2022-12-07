require 'rails_helper'

RSpec.describe "my items", type: :feature do
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }
  let(:group) { FactoryBot.create(:group) }

  # for some reason, this does not work and fails with the following exception
  # once i try to look at the membership in the debugger:
  # "error: undefined method `status=' for Membership"

  let(:membership) { FactoryBot.create(:membership, user: user, group: group, role: 1) }
  let(:item1) { FactoryBot.create(:item, name: 'Item 1') }
  let(:item2) { FactoryBot.create(:item, name: 'Item 2') }

  before do
    item1.manager_groups << group
  end

  # it "shows my items" do
  #   sign_in user
  #   visit my_items_path
  #   debugger
  #   expect(page).to have_text "Item 1"
  #   expect(page).to have_text "Item 2"
  # end
end
