require 'rails_helper'

RSpec.describe "landing_page/index", type: :view do
  before do
    assign(:items, [
             Item.create!(
               name: "Telepathie für Anfänger",
               description: "Ein hoch wissenschaftliches Buch über die Magie des Telefonierens",
               max_borrowing_days: 7
             ),
             Item.create!(
               name: "Schneewittchen",
               description: "Ein wunderschönes Märchen",
               max_borrowing_days: 7
             )
           ])
  end

  pending "test generated html"

  it "will never be merged into dev branch" do
      raise "This branch is not meant to be merged into dev and will only serve as a short lived demo"
  end

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
