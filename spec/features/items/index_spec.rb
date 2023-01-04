require "rails_helper"

describe "index item page", type: :feature do

  it "shows drop down menu when 'New Item' is clicked" do
    visit(items_path)
    group = page.find_by_id('dropdown-button-group')
    group.find_by('dropdownMenuButton').click
    expect(group).to have_css('.dropdown-item')
    expect(group).to have_link('Book', href: '/items/new?item_type=book')
    expect(group).to have_link('Movie')
    expect(group).to have_link('Other')
  end

  it "opens new page with respected item type when clicked on type" do
    visit(items_path)
    group = page.find_by_id('dropdown-button-group')
    group.find_by('dropdownMenuButton').click
    group.find('.dropdown-item', text: 'Book').click
    expect(page).to have_text('Number of pages')
  end

end
