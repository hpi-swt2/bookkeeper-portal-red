require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  let(:membership) do
    FactoryBot.create(:membership, :admin)
  end

  let(:group) do
    membership.group
  end

  let(:user) do
    membership.user
  end

  before do
    assign(:user, user)
    assign(:groups, user.groups)
  end

  it "renders a list of groups" do
    render
    expect(rendered).to have_text(group.name)
  end

  it "renders all but personal groups" do
    render
    expect(rendered).to have_no_text(user.personal_group.name)
  end
end
