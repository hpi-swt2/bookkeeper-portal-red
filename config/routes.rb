Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :items

  resources :items do
    patch :update_lending
  end

  devise_for :users
  # Defines the root path route ("/")
  root "landing_page#index"

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    # https://github.com/heartcombo/devise/blob/main/README.md

  end
end
