require "rails_helper"

describe "edit item page", type: :feature do
  before do
    @item = FactoryBot.create(:book)
    @user = FactoryBot.create(:user, email: 'example@mail.com')
    @user2 = FactoryBot.create(:user, email: 'example2@mail.com')
    @group = FactoryBot.create(:group)
    @group2 = FactoryBot.create(:group)
    FactoryBot.create(:permission, group: @group, item: @item, permission_type: :can_view)
    FactoryBot.create(:permission, group: @group2, item: @item, permission_type: :can_view)
    FactoryBot.create(:permission, group: @group, item: @item, permission_type: :can_manage)
    FactoryBot.create(:membership, user: @user, group: @group)
    FactoryBot.create(:membership, user: @user2, group: @group2)
  end

  it "show an error message if user has no managing rights" do
    sign_in @user2
    visit edit_item_path(@item)
    expect(page).to have_text(:visible, I18n.t("items.messages.not_allowed_to_edit"))
  end

  # rubocop:todo RSpec/NoExpectationExample
  it "renders succesfully and show item details if user has managing rights" do
    sign_in @user
    visit edit_item_path(@item)
    page.find_field("item[name]", with: @item.name)
    page.find_field("item[description]", with: @item.description)
  end
  # rubocop:enable RSpec/NoExpectationExample

  it "accepts input, redirect and update name in database" do
    sign_in @user
    visit edit_item_path(@item)
    page.fill_in "item[name]", with: "Harry Potter und die Kammer des Schreckens"
    page.find("button[type='submit'][value='#{@item.item_type}']").click
    expect(page).to have_text("Item was successfully updated.")
    expect((Item.find_by name: "Harry Potter und die Kammer des Schreckens").description).to eq(@item.description)
  end
end
