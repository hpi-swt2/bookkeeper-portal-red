# https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
class RegistrationsController < Devise::RegistrationsController
  protected

  # Allow users to edit their own description without entering their password
  # This is required because OIDC does not expose a password to the user
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # Forward user to their own profile page after changing their description
  def after_update_path_for(resource)
    profile_path(resource)
  end
end
