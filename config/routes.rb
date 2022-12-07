Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :items do
    patch :update_lending
    collection do
      get "/my", to: "items#my_items"
      get "/my/borrowed", to: "items#my_borrowed_items"
      get "/borrowed", to: "items#borrowed_items"
    end
  end

  # Add controllers for omniauth (openid connect)
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions"
             }

  # Defines the root path route ("/")
  root "landing_page#index"

  # Profile routes
  get "/profiles/me", to: "profiles#show_me"
  get "/profiles/:id", to: "profiles#show", as: :profile

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    # https://github.com/heartcombo/devise/blob/main/README.md
  end
end
