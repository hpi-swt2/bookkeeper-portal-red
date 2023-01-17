require 'rails_helper'

RSpec.describe "grid view", type: :feature do
  let(:password) { 'password' }
  let(:user1) { FactoryBot.create(:user, password: password) }
  let(:user2) { FactoryBot.create(:user, password: password) }

  before do
    # create some items
    item1 = FactoryBot.create(:book, name: 'BBB', created_at: 'Mon, 16 Jan 2023 15:39:17.645343000 UTC +00:00')
    item2 = FactoryBot.create(:movie, name: 'AAA', created_at: 'Sun, 15 Jan 2023 15:39:17.645343000 UTC +00:00')
    item3 = FactoryBot.create(:game, name: 'CCC', created_at: 'Tue, 17 Jan 2023 15:39:17.645343000 UTC +00:00')
  end

  it "can sort items by name" do
    sign_in user1
    visit "/items?q[s]=name"

    cards = page.all('div.card h5')

    print(cards)
    expect(cards[0]).to have_text("AAA")
    expect(cards[1]).to have_text("BBB")
    expect(cards[2]).to have_text("CCC")
  end

  it "can sort items by creation datetime" do
    sign_in user1
    visit "/items?q[s]=created_at+desc"

    cards = page.all('div.card h5')

    print(cards)
    expect(cards[0]).to have_text("CCC")
    expect(cards[1]).to have_text("BBB")
    expect(cards[2]).to have_text("AAA")
  end
end
