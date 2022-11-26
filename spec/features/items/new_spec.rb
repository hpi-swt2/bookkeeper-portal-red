require "rails_helper"

describe "new item page", type: :feature do
    before(:each) do
        @item_title = "Harry Potter und der Stein der Weisen"
        @item_description = "Buch von J.K.Rowling"
    end
    it "should render succesfully" do
        visit new_item_path
    end
    it "should accept input, redirect and write data into database" do
        visit new_item_path
        page.fill_in "item[name]", with: @item_title
        page.fill_in "item[description]", with: @item_description
        page.find("input[type='submit']").click
        expect(page).to have_text("Item was successfully created.")
        expect((Item.find_by name: @item_title).description).to eq(@item_description) 
    end

end