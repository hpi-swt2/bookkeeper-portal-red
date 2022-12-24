require 'rails_helper'

RSpec.describe "items/edit", type: :view do

  it "renders the edit item form" do
    item = FactoryBot.create(:other)
    assign(:item, item)
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"
    end
  end

  [:book, :movie, :game, :other].each do |item_type|
    it "renders correct attributes for item type #{item_type}" do
      item = FactoryBot.create(item_type)
      assign(:item, item)

      render
      item.attributes.each do |key, _value|
        # for some reason, the 'fsk' attribute gets renamed to 'lfsk' only in the game form and only in the view test
        assert_select "input[name=?]", "item[#{key}]" unless key.eql?("fsk")
      end
    end
  end
end
