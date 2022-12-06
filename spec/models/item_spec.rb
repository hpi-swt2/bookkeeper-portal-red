require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { FactoryBot.create(:item) }
  let(:user) { FactoryBot.create(:user) }

  it "can have multiple groups with different permissions" do
    group1 = FactoryBot.create(:group)
    group2 = FactoryBot.create(:group)
    group3 = FactoryBot.create(:group)

    item.permissions.create(group: group1, permission_type: :can_manage)
    item.permissions.create(group: group2, permission_type: :can_view)
    item.permissions.create(group: group3, permission_type: :can_lend)
    item.permissions.create(group: group3, permission_type: :can_view)

    expect(item.manager_groups.count).to eq(1)
    expect(item.manager_groups.first).to eq(group1)

    expect(item.viewer_groups.count).to eq(2)
    expect(item.viewer_groups.first).to eq(group2)
    expect(item.viewer_groups.second).to eq(group3)

    expect(item.lender_groups.count).to eq(1)
    expect(item.lender_groups.first).to eq(group3)
  end

  # it "is able to determine if it is borrowed by the current user" do
  #   expect(item.borrowed_by?(user)).to be false
  # end

  it "can be of different types" do
    book = FactoryBot.create(:book)
    expect((described_class.find_by name: book.name).item_type).to eq("book")

    movie = FactoryBot.create(:movie)
    expect((described_class.find_by name: movie.name).item_type).to eq("movie")

    game = FactoryBot.create(:game)
    expect((described_class.find_by name: game.name).item_type).to eq("game")

    other = FactoryBot.create(:other)
    expect((described_class.find_by name: other.name).item_type).to eq("other")
  end

  it "has attributes depending on it's type" do
    book = FactoryBot.create(:book)
    expect(book.attribute?("author")).to be true
    expect(book.attribute?("number_of_pages")).to be true
    expect(book.attribute?("fsk")).to be false
    expect(book.attribute?("format")).to be false

    movie = FactoryBot.create(:movie)
    expect(movie.attribute?("director")).to be true
    expect(movie.attribute?("genre")).to be true
    expect(movie.attribute?("publisher")).to be false
    expect(movie.attribute?("edition")).to be false

    game = FactoryBot.create(:game)
    expect(game.attribute?("illustrator")).to be true
    expect(game.attribute?("number_of_players")).to be true
    expect(game.attribute?("category")).to be false
    expect(game.attribute?("number_of_pages")).to be false

    other = FactoryBot.create(:other)
    expect(other.attribute?("name")).to be true
    expect(other.attribute?("category")).to be true
    expect(other.attribute?("release_date")).to be false
    expect(other.attribute?("isbn")).to be false
  end
end
