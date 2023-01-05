require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  let(:membership) do
    FactoryBot.create(:membership, :admin)
  end

  let(:group) do
    membership.group
  end

  before do
    assign(:user, membership.user)
    assign(:groups, [membership.group])
  end

  it "renders a list of groups" do
    render
    expect(rendered).to have_text(group.name)
  end
end
