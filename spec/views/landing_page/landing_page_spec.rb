require 'rails_helper'

RSpec.describe "landing_page/index", type: :view do
  before do
    user = FactoryBot.create(:user, password: "password")
    sign_in user
    @item1 = FactoryBot.create(
      :book,
      name: "Telepathie für Anfänger",
      description: "Ein hoch wissenschaftliches Buch über die Magie des Telefonierens",
      max_reservation_days: 2,
      max_borrowing_days: 7
    )
    @item2 = FactoryBot.create(
      :book,
      name: "Schneewittchen",
      description: "Ein wunderschönes Märchen",
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

  it "renders the landing page without errors" do
    expect(render).not_to be_empty
  end

  # check, if the html renders the name of the items

  it "renders the name of the items in the grid" do
    render
    expect(rendered).to match(/Telepathie für Anfänger/)
    expect(rendered).to match(/Schneewittchen/)
  end

  # check, if the html doesnt render the description of the items

  it "does not render the description of the items in the grid" do
    render
    expect(rendered).not_to match(/Ein hoch wissenschaftliches Buch über die Magie des Telefonierens/)
    expect(rendered).not_to match(/Ein wunderschönes Märchen/)
  end

end
