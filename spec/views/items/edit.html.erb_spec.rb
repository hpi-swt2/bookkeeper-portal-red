require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  let(:item) do
    Item.create!(
      name: "MyString",
      description: "MyString",
      max_reservation_days: 2,
      max_borrowing_days: 7
    )
  end

  before do
    assign(:item, item)
  end

  it "renders the edit item form" do
    item = FactoryBot.create(:other)
    assign(:item, item)
    render

    assert_select "form[action=?][method=?]", item_path(item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"
    end
  end

  it "contains a member counter" do
    item = FactoryBot.create(:other)
    assign(:item, item)
    render

    expect(response).to have_text('(1 Mitglied)')
  end

  [:book, :movie, :game, :other].each do |item_type|
    it "renders correct attributes for item type #{item_type}" do
      item = FactoryBot.create(item_type)
      assign(:item, item)

      render
      item.attributes.each do |key, _value|
        assert_select "input[name=?]", "item[#{key}]"
      end
    end
  end
end
