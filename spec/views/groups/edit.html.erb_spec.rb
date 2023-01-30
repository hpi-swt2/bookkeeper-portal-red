require 'rails_helper'

RSpec.describe "groups/edit", type: :view do
  let(:group) do
    FactoryBot.create(:group)
  end
  let(:user) do
    FactoryBot.create(:user)
  end

  it "renders the edit group form" do
    # This will assign the group object to the template instance variable
    assign(:group, group)
    render

    assert_select "form[action=?][method=?]", group_path(group), "post" do

      assert_select "input[name=?]", "group[name]"
    end
  end
  it "does not allow deleting or adding members to personal groups" do
    assign(:group, user.personal_group)
    render
    expect(rendered).to_not have_text(t(:group_add_member))
  end
end
