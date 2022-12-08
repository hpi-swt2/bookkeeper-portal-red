require "rails_helper"

describe "show item page", type: :feature do

  before do
    @item = Item.create!(
      name: "Harry Potter",
      description: "Author: J.K.Rowling"
    )
    @user = FactoryBot.create(:user, email: 'example@mail.com')
    group = FactoryBot.create(:group)
    membership = FactoryBot.create(:membership, user: @user, group: group)
    permission = FactoryBot.create(:permission, group: group, item: @item, permission_type: :can_lend)
  end

  context 'with multiple screensizes', driver: :selenium_chrome, ui: true do
    [[400, 600], [1000, 2000]].each do |screen_size|
      before do
        Capybara.current_session.current_window.resize_to(screen_size[0], screen_size[1])
      end

      it "renders succesfully and show item details" do
        sign_in @user
        visit item_path(@item)
        expect(page).to have_text(:visible, @item.name)
        expect(page).to have_text(:visible, @item.description)
      end
    end
  end

  it "renders succesfully and show item details" do
    sign_in @user
    visit item_path(@item)
    expect(page).to have_text(:visible, @item.name)
    expect(page).to have_text(:visible, @item.description)
  end
end
