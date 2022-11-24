class Users::SessionsController < Devise::SessionsController
  def create
    super
    flash[:notice] = "Welcome back, #{current_user.name}!" if current_user
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(_resource_or_scope)
    root_path
  end
end
