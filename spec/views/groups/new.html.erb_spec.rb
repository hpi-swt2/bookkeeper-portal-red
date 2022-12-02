require 'rails_helper'

RSpec.describe "groups/new", type: :view do
  let(:group) do
    # Just build (not saving to db) to let usr edit beforehand
    FactoryBot.build(:group)
  end

  # This will assign the group object to the template instance variable
  before do
    assign(:group, group)
  end

  it "renders new group form" do
    render

    assert_select "form[action=?][method=?]", groups_path, "post" do

      assert_select "input[name=?]", "group[name]"
    end
  end
end
