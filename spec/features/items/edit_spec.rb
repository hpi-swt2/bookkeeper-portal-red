require "rails_helper"

describe "edit item page", type: :feature do
  let(:item) do
    FactoryBot.create(
      :book,
      name: "Harry Potter",
      description: "Author: J.K.Rowling",
      max_reservation_days: 2,
      max_borrowing_days: 7
    )
  end

  before do
    # rubocop:todo Lint/UselessAssignment
    item = :item
    # rubocop:enable Lint/UselessAssignment
    @user = FactoryBot.create(:user, email: 'example@mail.com')
    @group = FactoryBot.create(:group)
    @membership = Membership.new(role: 1, user_id: @user.id, group: @group)
  end

  it "show an error message if user has no managing rights" do
    sign_in @user
    visit edit_item_path(item)
    expect(page).to have_text(:visible, "You are not allowed to edit this item.")
  end

  # rubocop:todo RSpec/NoExpectationExample
  it "renders succesfully and show item details if user has managing rights" do
    sign_in @user
    @user.memberships.push(@membership)
    item.manager_groups.push(@group)
    visit edit_item_path(item)
    page.find_field("item[name]", with: item.name)
    page.find_field("item[description]", with: item.description)
  end
  # rubocop:enable RSpec/NoExpectationExample

  it "accepts input, redirect and update name in database" do
    sign_in @user
    @user.memberships.push(@membership)
    item.manager_groups.push(@group)
    visit edit_item_path(item)
    page.fill_in "item[name]", with: "Harry Potter und die Kammer des Schreckens"
    page.find("button[type='submit'][value='#{item.item_type}']").click
    expect(page).to have_text("Item was successfully updated.")
    expect((Item.find_by name: "Harry Potter und die Kammer des Schreckens").description).to eq(item.description)
  end

  context 'with JS', driver: :selenium_chrome, js: true, ui: true do
    it "shows all availible groups in the permission list" do
      sign_in @user
      @user.memberships.push(@membership)
      item.manager_groups.push(@group)
      visit edit_item_path(item)
      page.find_by_id("add-permission-button").click
      expect(page.find_by_id("permission-group-select")).to have_selector("option", count: Group.count + 1)
    end


    it "updates the permission list when a new group is added" do
      sign_in @user
      @user.memberships.push(@membership)
      item.manager_groups.push(@group)
      visit edit_item_path(item)
      page.find_by_id("add-permission-button").click
      page.find_by_id("permission-group-select").find("option[value='#{Group.last.id}']").select_option
      page.find_by_id("permission-role-select").find("option[value='1']").select_option
      page.find_by_id("add-permission-button").click  
    end
    # sleep 0.5 # Waiting for JS to execute (not ideal, but works)
  end

end
