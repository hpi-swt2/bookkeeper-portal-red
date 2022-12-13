require "rails_helper"

describe "show item page", type: :feature do
  let(:item) do
    Item.create!(
      name: "Harry Potter",
      description: "Author: J.K.Rowling"
    )
  end
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }

  context 'with multiple screensizes', driver: :selenium_chrome, ui: true do
    [[400, 600], [1000, 2000]].each do |screen_size|
      before do
        Capybara.current_session.current_window.resize_to(screen_size[0], screen_size[1])
        # driven_by :selenium, using: :firefox, screen_size: screen_size
        # rubocop:todo Lint/UselessAssignment
        item = :item
        user = :user
        # rubocop:enable Lint/UselessAssignment
      end

      it "renders succesfully and show item details" do
        sign_in user
        visit item_path(item)
        expect(page).to have_text(:visible, item.name)
        expect(page).to have_text(:visible, item.description)
      end
    end
  end

  it "renders succesfully and show item details" do
    sign_in user
    visit item_path(item)
    expect(page).to have_text(:visible, item.name)
    expect(page).to have_text(:visible, item.description)
  end
end
