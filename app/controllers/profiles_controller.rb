class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def show_me
    redirect_to profile_path(current_user)
  end

  def edit_me
    redirect_to edit_user_registration_path
  end

  def remove_avatar
    @user = User.find(params[:id])
    if current_user == @user && @user.avatar
      @user.avatar.purge
      return redirect_to profile_url(@user), notice: I18n.t("items.messages.successfully_destroyed_image")
    end
    redirect_to profile_url(@item), notice: I18n.t("profile.messages.not_allowed_to_edit")
  end
end
