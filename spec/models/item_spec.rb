require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { FactoryBot.create(:item) }
  let(:user) { FactoryBot.create(:user) }

  describe "borrowing and reservation methods" do
    context "when user has lending rights" do
      before do
        group = FactoryBot.create(:group)
        FactoryBot.create(:membership, user: user, group: group)
        FactoryBot.create(:permission, item: item, group: group, permission_type: :can_borrow)
      end

      it "does not find reservations if none exist" do
        expect(item.current_reservation).to be_nil
        expect(item.reserved?).to be false
        expect(item.not_reserved?).to be true
        expect(item.borrowed?).to be false
        expect(item.not_borrowed?).to be true
        expect(item.reserved_by?(user)).to be false
        expect(item.borrowed_by?(user)).to be false

        expect(item.borrowable_by?(user)).to be true
        expect(item.reservable_by?(user)).to be true
      end

      it "can get the current reservation" do
        reservation = FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: Time.zone.now,
                                                      ends_at: 2.days.from_now)
        expect(item.current_reservation).to eq(reservation)
        expect(item.reserved?).to be true
        expect(item.not_reserved?).to be false
        expect(item.borrowed?).to be false
        expect(item.not_borrowed?).to be true
        expect(item.reserved_by?(user)).to be true
        expect(item.borrowed_by?(user)).to be false

        expect(item.borrowable_by?(user)).to be true
        expect(item.reservable_by?(user)).to be false
      end

      it "ignores old reservations" do
        FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: 4.days.ago,
                                        ends_at: 2.days.ago)
        expect(item.current_reservation).to be_nil

        expect(item.reserved?).to be false
        expect(item.not_reserved?).to be true
        expect(item.borrowed?).to be false
        expect(item.not_borrowed?).to be true
        expect(item.reserved_by?(user)).to be false
        expect(item.borrowed_by?(user)).to be false

        expect(item.borrowable_by?(user)).to be true
        expect(item.reservable_by?(user)).to be true
      end

      it "can get the current lending" do
        FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: Time.zone.now, completed_at: nil,
                                    due_at: 2.days.from_now)
        expect(item.current_reservation).to be_nil
        expect(item.reserved?).to be false
        expect(item.not_reserved?).to be true
        expect(item.borrowed?).to be true
        expect(item.not_borrowed?).to be false
        expect(item.reserved_by?(user)).to be false
        expect(item.borrowed_by?(user)).to be true

        expect(item.borrowable_by?(user)).to be false
        expect(item.reservable_by?(user)).to be false
      end

      it "ignores old lendings" do
        FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: 2.days.ago,
                                    completed_at: 1.day.ago, due_at: Time.zone.now)
        expect(item.current_reservation).to be_nil
        expect(item.reserved?).to be false
        expect(item.not_reserved?).to be true
        expect(item.borrowed?).to be false
        expect(item.not_borrowed?).to be true
        expect(item.reserved_by?(user)).to be false
        expect(item.borrowed_by?(user)).to be false

        expect(item.borrowable_by?(user)).to be true
        expect(item.reservable_by?(user)).to be true
      end
    end

    context "when user doesn't have lending rights" do
      it "does not allow reservation or borrowing" do
        expect(item.borrowable_by?(user)).to be false
        expect(item.reservable_by?(user)).to be false
      end
    end

    context "when another user exists" do
      let(:user2) { FactoryBot.create(:user) }

      before do
        group = FactoryBot.create(:group)
        FactoryBot.create(:membership, user: user, group: group)
        FactoryBot.create(:permission, item: item, group: group, permission_type: :can_borrow)

        FactoryBot.create(:membership, user: user2, group: group)
      end

      it "does not allow reservation or borrowing by user2 if user has a lending" do
        FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: Time.zone.now, completed_at: nil,
                                    due_at: 2.days.from_now)

        expect(item.borrowable_by?(user2)).to be false
        expect(item.reservable_by?(user2)).to be false
      end

      it "does not allow reservation or borrowing by user2 if user has a reservation" do
        FactoryBot.create(:reservation, item_id: item.id, user_id: user.id, starts_at: Time.zone.now,
                                        ends_at: 2.days.from_now)

        expect(item.borrowable_by?(user2)).to be false
        expect(item.reservable_by?(user2)).to be false
      end

    end
  end

  it "can have multiple groups with different permissions" do
    group1 = FactoryBot.create(:group)
    group2 = FactoryBot.create(:group)
    group3 = FactoryBot.create(:group)

    item.permissions.create(group: group1, permission_type: :can_manage)
    item.permissions.create(group: group2, permission_type: :can_view)
    item.permissions.create(group: group3, permission_type: :can_borrow)
    item.permissions.create(group: group3, permission_type: :can_view)

    expect(item.manager_groups.count).to eq(1)
    expect(item.manager_groups.first).to eq(group1)

    expect(item.viewer_groups.count).to eq(2)
    expect(item.viewer_groups.first).to eq(group2)
    expect(item.viewer_groups.second).to eq(group3)

    expect(item.borrower_groups.count).to eq(1)
    expect(item.borrower_groups.first).to eq(group3)
  end

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
