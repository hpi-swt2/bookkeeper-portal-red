require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
end
RSpec.describe "items/show", type: :view do
  before do
    assign(:item, FactoryBot.create(
                    :item,
                    name: "Name",
                    description: "Description",
                    max_borrowing_days: 7
                  ))
  end

  it "renders attributes in <p>" do
    user = FactoryBot.create(:user, password: "password")
    sign_in user
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
