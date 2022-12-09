class ApplicationController < ActionController::Base
  # skip authentication during tests
  before_action :authenticate_user! unless Rails.env.test?

  before_action :set_locale

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  before_action :set_search

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :current_password, :description])
  end

  private

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale.to_sym : nil
  end

  def set_search
    @q=Item.ransack(params[:q])
  end
end
