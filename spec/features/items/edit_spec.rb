require "rails_helper"

describe "edit item page", type: :feature do
  item = Item.create!(
    name: "Harry Potter",
    description: "Author: J.K.Rowling",
    max_borrowing_days: 7
  )
  user = FactoryBot.create(:user, email: "user#{rand(100_000)}@example.com")
  group = FactoryBot.create(:group)

  FactoryBot.create(:permission, item_id: item.id, group_id: group.id, permission_type: :can_manage)
  FactoryBot.create(:membership, user_id: user.id, group_id: group.id)

  before do
    sign_in user
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
    page.find("input[type='submit'][value='Update item']").click
    expect(page).to have_text("Item was successfully updated.")
    expect((Item.find_by name: "Harry Potter und die Kammer des Schreckens").description).to eq(item.description)
  end
end
