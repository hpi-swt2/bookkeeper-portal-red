require "rails_helper"

describe "show item page", type: :feature do
  let(:item) do
    Item.create!(
      name: "Harry Potter",
      description: "Author: J.K.Rowling"
    )
  end
  [[400,600], [1000,2000]].each do |screen_size|
    context 'with multiple screensizes' do
      before(:each) do
        Capybara.current_session.driver.browser.manage.window.resize_to(screen_size[0], screen_size[1]) if Capybara.current_session.driver.browser.respond_to? 'manage'
        item = :item
      end
      it "should render succesfully and show item details" do
        visit item_path(item)
        expect(page).to have_text(:visible,item.name)
        expect(page).to have_text(:visible,item.description)
      end
    end
  end
end