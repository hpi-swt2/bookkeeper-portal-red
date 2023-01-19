require "rails_helper"

describe "returining process", type: :feature do
  let(:item) { FactoryBot.create(:item) }
  let(:password) { 'password' }
  let(:user) { FactoryBot.create(:user, email: 'example@mail.com', password: password) }
  let(:user2) { FactoryBot.create(:user, password: password) }

  before do
    manage_group = FactoryBot.create(:group)
    borrow_group = FactoryBot.create(:group)
    FactoryBot.create(:membership, user: user, group: borrow_group)
    FactoryBot.create(:membership, user: user2, group: manage_group)
    FactoryBot.create(:membership, user: user2, group: borrow_group)
    FactoryBot.create(:permission, item: item, group: borrow_group, permission_type: :can_borrow)
    FactoryBot.create(:permission, item: item, group: manage_group, permission_type: :can_manage)
    FactoryBot.create(:permission, item: item, group: borrow_group, permission_type: :can_view)
    FactoryBot.create(:permission, item: item, group: manage_group, permission_type: :can_view)
  end

  context "with two users - one with management rights -" do

    it "does return the correct item, when it is returned by the owner" do
      time = Time.zone.now
      FactoryBot.create(:lending, item_id: item.id, user_id: user.id, started_at: time, completed_at: nil,
                                  due_at: 2.days.from_now)
      sign_in user2
      visit item_path(item)
      expect(page).to have_text(:visible, I18n.t("items.buttons.owner-return"))
      page.find_button(I18n.t("items.buttons.owner-return"), match: :first).click
      lending = Lending.where(item_id: item.id, user_id: user.id).where(["completed_at > :time", { time: time }]).first
      expect(lending).not_to be_nil
    end
  end
end
