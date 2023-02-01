require 'rails_helper'

RSpec.describe "items/index", type: :view do

  before do
    user = FactoryBot.create(:user, password: "password")
    sign_in user
    @item1 = FactoryBot.create(
      :book,
      name: "Communist Manifesto",
      author: "Karl Marx",
      genre: "",
      description: "A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red",
      max_reservation_days: 2,
      max_borrowing_days: 7
    )
    @item2 = FactoryBot.create(
      :book,
      name: "The Hitchhikers Guide to the Galaxy",
      genre: "",
      description: "A science fiction comedy adventure",
      max_reservation_days: 2,
      max_borrowing_days: 7
    )
    assign(:items, [@item1, @item2])
    group = FactoryBot.create(:group)
    FactoryBot.create(:membership, user: user, group: group)
    FactoryBot.create(:permission, item: @item1, group: group, permission_type: :can_view)
    FactoryBot.create(:permission, item: @item2, group: group, permission_type: :can_view)
    # initialize search and filter
    @q = Item.ransack(params[:q])
  end

  pending "test generated html"

  # check, if the html renders without errors

  it "renders the html without errors" do
    expect(render).not_to be_empty
  end

  # check, if the html renders the name of the items

  it "renders the name of the items" do
    render
    expect(rendered).to match(/Communist Manifesto/)
    expect(rendered).to match(/The Hitchhikers Guide to the Galaxy/)
  end

  # check, if the html doesnt render the description of the items

  it "does not render the description of the items" do
    render
    expect(rendered).not_to match(/A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red/)
    expect(rendered).not_to match(/A science fiction comedy adventure/)
  end

  it "renders important item attributes based on item_type" do
    render
    expect(rendered).to match(/Karl Marx/)
    expect(rendered).to match(I18n.t("items.form.book.author"))
  end

  it "does not render important item attributes if empty" do
    render
    expect(rendered).not_to match(I18n.t("items.form.book.genre"))
  end

  it "renders item cards that are clickable" do
    render
    expect(rendered).to have_css(".card a img")
    expect(rendered).to have_css(".card-body a")
  end
end
