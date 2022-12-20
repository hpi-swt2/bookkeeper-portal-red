# https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
class RegistrationsController < Devise::RegistrationsController

    protected

    def update_resource(resource, params)
        resource.update_without_password(params)
    end
end