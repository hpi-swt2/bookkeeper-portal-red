require 'rails_helper'

RSpec.describe "borrowed items", type: :feature do
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, password: password) }

  before do
    communist_manifest = Item.create!(
      name: "Communist Manifesto",
      description: "A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red"
    )
    hitchhikers_guide = Item.create!(
      name: "The Hitchhikers Guide to the Galaxy",
      description: "A science fiction comedy adventure"
    )
    Item.create!(
      name: "QualityLand",
      description: "A book about a fictional country"
    )

    Lending.create!(
      item: communist_manifest,
      user: user,
      started_at: DateTime.parse('January 1st 2022 00:00:00 AM'),
      due_at: DateTime.parse('February 1st 2022 00:00:00 AM'),
      created_at: DateTime.parse('January 1st 2022 00:00:00 AM'),
      updated_at: DateTime.parse('January 1st 2022 00:00:00 AM')
    )

    Lending.create!(
      item: hitchhikers_guide,
      user: user,
      started_at: DateTime.parse('January 1st 2022 00:00:00 AM'),
      completed_at: DateTime.parse('January 2nd 2022 00:00:00 AM'),
      due_at: DateTime.parse('February 1st 2022 00:00:00 AM'),
      created_at: DateTime.parse('January 1st 2022 00:00:00 AM'),
      updated_at: DateTime.parse('January 1st 2022 00:00:00 AM')
    )
  end

  it "shows borrowed items" do
    sign_in user
    visit borrowed_items_path

    expect(page).to have_text "Communist Manifesto"
  end

  it "doesn't show items that were already returned" do
    sign_in user
    visit borrowed_items_path

    expect(page).not_to have_text "The Hitchhikers Guide to the Galaxy"
  end

  it "doesn't show unborrowed items" do
    sign_in user
    visit borrowed_items_path

    expect(page).not_to have_text "QualityLand"
  end
end
