class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def show_me
    redirect_to profile_path(current_user)
  end
end
