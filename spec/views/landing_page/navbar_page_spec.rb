require 'rails_helper'

RSpec.describe "layouts/_navbar", type: :view do
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
  end

  pending "renders 'new item' navbar-button"

  pending "navbar shows drop down menu when 'New Item' is clicked"

  pending "opens new page with respected item type when clicked on type"

end
