# https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
class RegistrationsController < Devise::RegistrationsController
  protected

  # Disable the Rails/LexicallyScopedActionFilter cop for this method
  # because it is a Devise method that is called by the framework
  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :validate_telephone_number, only: :update
  # rubocop:enable Rails/LexicallyScopedActionFilter

  # Allow users to edit their own description without entering their password
  # This is required because OIDC does not expose a password to the user
  def update_resource(resource, params)
    resource.update_without_password(params.permit(:telephone_number, :description))
  end

  # Forward user to their own profile page after changing their description
  def after_update_path_for(resource)
    profile_path(resource)
  end

  # Strong parameters for updating the user
  def account_update_params
    params.require(:user).permit(:telephone_number, :description)
  end

  # Validate the telephone number before updating the user
  def validate_telephone_number
    return unless params[:user][:telephone_number].present? && !params[:user][:telephone_number].match(/\A[+\-\d\s]+\z/)

    flash[:error] = I18n.t("profile.phone_number_warning")
    redirect_to edit_user_registration_path
  end
end
