Rails.application.routes.draw do
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    # https://github.com/heartcombo/devise/blob/main/README.md
    devise_for :users

    # Profile routes
    get "/profiles/me", to: "profiles#show_me"
    get "/profiles/:id", to: "profiles#show", as: :profile

    # Defines the root path route ("/")
    root "landing_page#index"
  end
end
