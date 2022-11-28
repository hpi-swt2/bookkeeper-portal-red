require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bookkeeper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.i18n.available_locales = [:en, :de]
    config.i18n.default_locale = :en

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Action Mailer Configuration for Gmail
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      user_name:            ENV.fetch("MAIL_USERNAME"),
      password:             ENV.fetch("MAIL_PASSWORD"),
      authentication:       'plain',
      enable_starttls_auto: true,
      open_timeout:         5,
      read_timeout:         5 }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
