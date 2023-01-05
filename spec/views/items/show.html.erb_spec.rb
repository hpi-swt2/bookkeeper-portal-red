require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
end
RSpec.describe "items/show", type: :view do
  let(:user) do
    FactoryBot.create(:user, password: "password")
  end

  it "renders attributes in <p>" do
    assign(:item, FactoryBot.create(
                    :other,
                    name: "Name",
                    description: "Description",
                    max_reservation_days: 2,
                    max_borrowing_days: 7
                  ))

    sign_in user
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end

  [:book, :movie, :game, :other].each do |item_type|
    it "renders correct attributes for item type #{item_type}" do
      item = FactoryBot.create(item_type)
      assign(:item, item)

      sign_in user
      render
      item.attributes.each do |_key, value|
        expect(rendered).to match(/#{value}/)
      end
    end
  end
end
