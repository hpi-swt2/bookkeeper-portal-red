require 'rails_helper'

RSpec.describe "landing_page/index", type: :view do
  before(:each) do
    user = FactoryBot.create(:user, password: "password")
    sign_in user
    assign(:items, [
             Item.create!(
               name: "Telepathie für Anfänger",
               description: "Ein hoch wissenschaftliches Buch über die Magie des Telefonierens"
             ),
             Item.create!(
               name: "Schneewittchen",
               description: "Ein wunderschönes Märchen"
             )
           ])
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
