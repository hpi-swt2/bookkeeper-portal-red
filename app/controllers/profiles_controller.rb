class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def show_me
    redirect_to profile_path(current_user)
  end

  def switch_user
    sign_in(User.find(params[:id]))
    redirect_to profiles_me_path
  end
end
