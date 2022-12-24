require "rails_helper"

describe "edit item page", type: :feature do
  let(:item) do
    FactoryBot.create(
      :book,
      name: "Harry Potter",
      description: "Author: J.K.Rowling"
    )
  end

  before do
    # rubocop:todo Lint/UselessAssignment
    item = :item
    # rubocop:enable Lint/UselessAssignment
  end

  # rubocop:todo RSpec/NoExpectationExample
  it "renders succesfully and show item details" do
    visit edit_item_path(item)
    page.find_field("item[name]", with: item.name)
    page.find_field("item[description]", with: item.description)
  end
  # rubocop:enable RSpec/NoExpectationExample

  it "accepts input, redirect and update name in database" do
    visit edit_item_path(item)
    page.fill_in "item[name]", with: "Harry Potter und die Kammer des Schreckens"
    page.find("button[type='submit'][value='#{item.item_type}']").click
    expect(page).to have_text("Item was successfully updated.")
    expect((Item.find_by name: "Harry Potter und die Kammer des Schreckens").description).to eq(item.description)
  end
end
