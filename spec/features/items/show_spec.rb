require "rails_helper"

describe "show item page", type: :feature do
  before do
    @item = Item.create!(
      name: "Harry Potter",
      description: "Author: J.K.Rowling",
      max_borrowing_days: 7,
      max_reservation_days: 2
    )
    @user = FactoryBot.create(:user, email: 'example@mail.com')
    group = FactoryBot.create(:group)
    FactoryBot.create(:membership, user: @user, group: group)
    FactoryBot.create(:permission, group: group, item: @item, permission_type: :can_borrow)
  end

  [[1600, 900], [400, 600]].each do |screen_size|
    context 'with multiple screensizes', driver: :selenium_chrome, ui: true do
      before do
        Capybara.current_session.current_window.resize_to(screen_size[0], screen_size[1])
      end

      it "renders succesfully and show item details" do
        sign_in @user
        visit item_path(@item)
        expect(page).to have_text(:visible, @item.name)
        expect(page).to have_text(:visible, @item.description)
      end

      it "only shows borrow button if src=qrcode is present" do
        sign_in @user
        visit "#{item_path(@item)}?src=qrcode"
        expect(page).to have_text(:visible, "Borrow")
      end

      it "doesn't show borrow button if src=qrcode is not present" do
        sign_in @user
        visit item_path(@item)
        expect(page).not_to have_text(:visible, "Borrow")
      end

      it "doesn't show borrow button if src=not-qrcode" do
        sign_in @user
        visit "#{item_path(@item)}?src=not-qrcode"
        expect(page).not_to have_text(:visible, "Borrow")
      end
    end
  end

  it "renders succesfully and show item details" do
    sign_in @user
    visit item_path(@item)
    expect(page).to have_text(:visible, @item.name)
    expect(page).to have_text(:visible, @item.description)
  end

  it "has working search field inside navbar" do
    item2 = FactoryBot.create(:movie)

    visit edit_item_path(@item)

    search = find(:css, "input[type='search'][placeholder='Search']")
    search.fill_in with: item2.name

    submit = find(:css, "button[type='submit'][value='search']")
    submit.click

    expect(page).to have_text(item2.name)
  end

end
