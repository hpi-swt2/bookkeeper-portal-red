class ApplicationController < ActionController::Base

    before_action :set_locale

    private

    # def default_url_options()
    #     { :locale => ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) }
    # end

    def set_locale
        if cookies[:my_locale] && I18n.available_locales.include?(cookies[:my_locale].to_sym)
          l = cookies[:my_locale].to_sym
        else
          l = I18n.default_locale
          cookies.permanent[:my_locale] = l
        end
        I18n.locale = l
    end

    def extract_locale
        parsed_locale = params[:locale]
        I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale.to_sym : nil
    end
end
