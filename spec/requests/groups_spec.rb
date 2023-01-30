require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/groups", type: :request do

  # This should return the minimal set of attributes required to create a valid
  # Group. As you add validations to Group, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: "Valid Groupname" }
  end

  let(:invalid_attributes) do
    { name: "" }
  end

  let(:membership) do
    FactoryBot.create(:membership, :admin)
  end

  let(:group) do
    membership.group
  end

  before do
    sign_in membership.user
  end

  describe "GET /index" do
    it "renders a successful response" do
      get groups_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      get edit_group_url(group)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Group" do
        expect do
          post groups_url, params: { group: valid_attributes }
        end.to change(Group, :count).by(1)
      end

      it "redirects to the created group" do
        post groups_url, params: { group: valid_attributes }
        expect(response).to redirect_to(groups_url)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Group" do
        expect do
          post groups_url, params: { group: invalid_attributes }
        end.not_to change(Group, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post groups_url, params: { group: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { name: "Another Group" }
      end

      it "updates the requested group" do
        expect do
          patch group_url(group), params: { group: new_attributes }
          group.reload
        end.to change(group, :name)
      end

      it "redirects to the group" do
        patch group_url(group), params: { group: new_attributes }
        group.reload
        expect(response).to redirect_to(edit_group_url(group))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch group_url(group), params: { group: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested group" do
      expect do
        delete group_url(group)
      end.to change(Group, :count).by(-1)
    end

    it "does not destroy a personal group" do
      group.personal_group!
      expect do
        delete group_url(group)
      end.to change(Group, :count).by(0)
    end

    it "redirects to the groups list" do
      delete group_url(group)
      expect(response).to redirect_to(groups_url)
    end
  end
  describe "POST /groups/:id/leave" do
    it "does not allow you to leave personal group" do
      puts group_leave_url(membership.user.personal_group)
      post group_leave_url(membership.user.personal_group)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
