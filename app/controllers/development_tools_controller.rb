class DevelopmentToolsController < ApplicationController
  # Sign in a user based on the passed user ID
  # WARNING: SHOULD NEVER BE ENABLED IN PRODUCTION USE!
  def switch_user
    raise "User switching should never be called outside of development environment" unless Rails.env.development?

    sign_out(current_user)
    sign_in(User.find(params[:id]))
    redirect_to profiles_me_path
  end
end
