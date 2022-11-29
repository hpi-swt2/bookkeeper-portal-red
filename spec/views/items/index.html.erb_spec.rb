require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before do
    assign(:items, [
      Item.create!(
        name: "Communist Manifesto",
        description: "A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red"
      ),
      Item.create!(
        name: "The Hitchhikers Guide to the Galaxy",
        description: "A science fiction comedy adventure"
      )
    ])
  end

  pending "test generated html"

  #check, if the html renders without errors

  it "renders the html without errors" do
    render
  end

  #check, if the html renders the name of the items

  it "renders the name of the items" do
    render
    expect(rendered).to match(/Communist Manifesto/)
    expect(rendered).to match(/The Hitchhikers Guide to the Galaxy/)
  end

  #check, if the html doesnt render the description of the items

  it "does not render the description of the items" do
    render
    expect(rendered).not_to match(/A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red/)
    expect(rendered).not_to match(/A science fiction comedy adventure/)
  end








end
