require "rails_helper"

describe "new item page", type: :feature do
  before do
    @user = FactoryBot.create(:user, email: 'example@mail.com')
    sign_in @user
    @item_title = "Harry Potter und der Stein der Weisen"
    @item_description = "Buch von J.K.Rowling"
    @item_max_reservation_days = 2
    @item_max_borrowing_days = 7
  end

  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }

  # rubocop:todo RSpec/NoExpectationExample
  it "renders succesfully" do
    visit new_item_path
  end
  # rubocop:enable RSpec/NoExpectationExample

  it "accepts input, redirect and write data into database" do
    @item_title = "Harry Potter und der Stein der Weisen"
    @item_description = "Buch von J.K.Rowling"
    @item_max_reservation_days = 2
    @item_max_borrowing_days = 7

    sign_in user
    visit new_item_path
    page.fill_in "item[name]", with: @item_title
    page.fill_in "item[description]", with: @item_description
    page.fill_in "item[max_borrowing_days]", with: @item_max_borrowing_days
    page.fill_in "item[max_reservation_days]", with: @item_max_reservation_days
    page.click_button("item_type")
    expect(page).to have_text("Item was successfully created.")
    expect((Item.find_by name: @item_title).description).to eq(@item_description)
  end

  # this does not work yet, because the permissions are not cascading yet
  # it "sets the managing, borrowing and viewing rights of the item creator" do
  #   sign_in user
  #   expect(user.exists_personal_group?).to be(true)

  #   personal_group = user.personal_group
  #   expect(personal_group.managed_items.count).to eq(0)
  #   expect(personal_group.viewable_items.count).to eq(0)
  #   expect(personal_group.borrowable_items.count).to eq(0)

  #   visit new_item_path
  #   page.fill_in "item[name]", with: "An item name"
  #   page.click_button("item_type")

  #   item = Item.find_by(name: "An item name")
  #   expect(personal_group.managed_items.count).to eq(1)
  #   expect(personal_group.managed_items.first).to eq(item)
  #   expect(user.can_manage?(item)).to be(true)

  #   expect(personal_group.viewable_items.count).to eq(1)
  #   expect(personal_group.viewable_items.first).to eq(item)

  #   expect(personal_group.borrowable_items.count).to eq(1)
  #   expect(personal_group.borrowable_items.first).to eq(item)
  #   expect(user.can_borrow?(item)).to be(true)
  # end
end
