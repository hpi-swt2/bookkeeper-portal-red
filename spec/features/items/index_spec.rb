require "rails_helper"

describe "index item page", type: :feature do

  it "shows drop down menu when 'New Item' is clicked" do
    visit(items_path)
    btn_group = page.find_by_id('dropdown-button-group')
    btn_group.find_by_id('dropdownMenuButton').click # rubocop:disable Rails/DynamicFindBy
    expect(btn_group).to have_css('.dropdown-item')
    expect(btn_group).to have_link('Book', href: '/items/new?item_type=book')
    expect(btn_group).to have_link('Movie')
    expect(btn_group).to have_link('Other')
  end

  it "opens new page with respected item type when clicked on type" do
    visit(items_path)
    btn_group = page.find_by_id('dropdown-button-group')
    btn_group.find_by_id('dropdownMenuButton').click # rubocop:disable Rails/DynamicFindBy
    btn_group.find('.dropdown-item', text: 'Book').click
    expect(page).to have_text('Number of pages')
  end

end
