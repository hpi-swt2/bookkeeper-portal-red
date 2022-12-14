require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before do
    assign(:item, Item.new(
                    name: "MyString",
                    description: "MyString",
                    max_reservation_days: 2
                  ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"
    end
  end
end
