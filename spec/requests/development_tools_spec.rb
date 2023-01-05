require 'rails_helper'

RSpec.describe "DevelomentTools", type: :request do
  describe "GET /sign_in" do
    it "returns http success" do
      get "/develoment_tools/sign_in"
      expect(response).to have_http_status(:success)
    end
  end

end
