require "rails_helper"

RSpec.describe GroupNameComponent, type: :component do
  let(:group) do
    FactoryBot.create(:group)
  end

  let(:verified_group) do
    FactoryBot.create(:group, :verified)
  end

  it "renders verified mark for verified groups" do
    render_inline(described_class.new(group: verified_group))

    expect(page).to have_text(
      verified_group.name
    ).and have_css(
      ".bi-patch-check"
    )
  end

  it "renders no verified mark for not verified groups" do
    render_inline(described_class.new(group: group))

    expect(page).to have_text(
      group.name
    ).and have_no_css(
      ".bi-patch-check"
    )
  end
end
