require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        name: "Name",
        description: "Description"
      ),
      Item.create!(
        name: "Name",
        description: "Description"
      )
    ])
  end

  pending "test generated html"
end