Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  # https://github.com/heartcombo/devise/blob/main/README.md
    devise_for :users
    resources :items
    # Defines the root path route ("/")
    root "landing_page#index"
  end
end
