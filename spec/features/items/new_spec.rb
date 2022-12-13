require "rails_helper"

describe "new item page", type: :feature do
  before do
    @item_title = "Harry Potter und der Stein der Weisen"
    @item_description = "Buch von J.K.Rowling"
    @item_max_borrowing_days = 7
  end

  # rubocop:todo RSpec/NoExpectationExample
  it "renders succesfully" do
    visit new_item_path
  end
  # rubocop:enable RSpec/NoExpectationExample

  it "accepts input, redirect and write data into database" do
    visit new_item_path
    page.fill_in "item[name]", with: @item_title
    page.fill_in "item[description]", with: @item_description
    page.fill_in "item[max_borrowing_days]", with: @item_max_borrowing_days
    page.find("button[type='submit'][id='item_submit']").click
    expect(page).to have_text("Item was successfully created.")
    expect((Item.find_by name: @item_title).description).to eq(@item_description)
  end

end
