require "rails_helper"

describe "show item page", type: :feature do
  before do
    @item = FactoryBot.create(:book)
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
        expect(page).to have_button(I18n.t('items.buttons.borrow'))
      end

      it "doesn't show borrow button if src=qrcode is not present" do
        sign_in @user
        visit item_path(@item)
        expect(page).not_to have_button(I18n.t('items.buttons.borrow'))
      end

      it "doesn't show borrow button if src=not-qrcode" do
        sign_in @user
        visit "#{item_path(@item)}?src=not-qrcode"
        expect(page).not_to have_button(I18n.t('items.buttons.borrow'))
      end
    end
  end

  it "renders succesfully and show item details" do
    sign_in @user
    visit item_path(@item)
    expect(page).to have_text(:visible, @item.name)
    expect(page).to have_text(:visible, @item.description)
  end

  it "displays an infotext if src=qrcode is not present and the item is reserved by the current user" do
    FactoryBot.create(:reservation, item_id: @item.id, user_id: @user.id, starts_at: Time.zone.now,
                                    ends_at: 2.days.from_now)
    sign_in @user
    visit item_path(@item)
    expect(page).to have_text(:visible, I18n.t("items.infobox.borrow.heading"))
    expect(page).to have_text(:visible, I18n.t("items.infobox.borrow.body"))
  end

  it "does not display an infotext if src=qrcode is present and the item is reserved by the current user" do
    FactoryBot.create(:reservation, item_id: @item.id, user_id: @user.id, starts_at: Time.zone.now,
                                    ends_at: 2.days.from_now)
    sign_in @user
    visit "#{item_path(@item)}?src=qrcode"
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.borrow.heading"))
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.borrow.body"))
  end

  it "displays an infotext if src=qrcode is not present and the item is borrowed by the current user" do
    FactoryBot.create(:lending, item_id: @item.id, user_id: @user.id, started_at: Time.zone.now, completed_at: nil,
                                due_at: 2.days.from_now)
    sign_in @user
    visit item_path(@item)
    expect(page).to have_text(:visible, I18n.t("items.infobox.return.heading"))
    expect(page).to have_text(:visible, I18n.t("items.infobox.return.body"))
  end

  it "does not display an infotext if src=qrcode is present and the item is borrowed by the current user" do
    FactoryBot.create(:lending, item_id: @item.id, user_id: @user.id, started_at: Time.zone.now, completed_at: nil,
                                due_at: 2.days.from_now)
    sign_in @user
    visit "#{item_path(@item)}?src=qrcode"
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.return.heading"))
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.return.body"))
  end

  it "displays an infotext if the user has no borrowing permissions" do
    @item2 = FactoryBot.create(:movie)
    sign_in @user
    visit item_path(@item2)
    expect(page).to have_text(:visible, I18n.t("items.infobox.missing_borrowing_permissions.heading"))
    expect(page).to have_text(:visible, I18n.t("items.infobox.missing_borrowing_permissions.body"))
  end

  it "does not display an infotext if the user has borrowing permissions" do
    sign_in @user
    visit item_path(@item)
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.missing_borrowing_permissions.heading"))
    expect(page).not_to have_text(:visible, I18n.t("items.infobox.missing_borrowing_permissions.body"))
  end

  it "has a 'no-access' status badge if the user has no borrowing permissions" do
    @item2 = FactoryBot.create(:movie)
    sign_in @user
    visit item_path(@item2)
    expect(page).to have_text(:visible, I18n.t("items.status_badge.no_access"))
  end

  it "has working search field inside navbar" do
    sign_in @user
    item2 = FactoryBot.create(:movie)

    sign_in @user
    visit edit_item_path(@item)

    search = find(:css, "input[type='search'][placeholder='Search']")
    search.fill_in with: item2.name

    submit = find(:css, "button[type='submit'][value='search']")
    submit.click

    expect(page).to have_text(item2.name)
  end

  it "display edit, delete and download button if user has managing rights" do
    sign_in @user

    group = FactoryBot.create(:group)
    membership = Membership.new(role: 1, user_id: @user.id, group: group)

    @user.memberships.push(membership)
    @item.manager_groups.push(group)

    visit item_path(@item)
    expect(page).to have_text(:visible, "Edit item")
    expect(page).to have_text(:visible, "Delete item")
    expect(page).to have_text(:visible, "Download QR-Code")
  end

  it "not display edit, delete and download button if user has no managing rights" do
    sign_in @user
    visit item_path(@item)
    expect(page).not_to have_text(:visible, I18n.t("items.buttons.edit"))
    expect(page).not_to have_text(:visible, I18n.t("items.buttons.delete"))
    expect(page).not_to have_text(:visible, I18n.t("items.buttons.download_qrcode"))
  end
end
