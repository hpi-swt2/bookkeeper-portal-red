class ProfilesController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def show_me
    @user = User.find(current_user.id)
    render :show
  end
end
