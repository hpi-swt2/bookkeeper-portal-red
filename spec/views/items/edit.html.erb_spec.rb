require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) do
    Item.create!(
      name: "MyString",
      description: "MyString",
      max_borrowing_days: 7
    )
  end

  before do
    assign(:item, item)
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"
    end
  end
end
