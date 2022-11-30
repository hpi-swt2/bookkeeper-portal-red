Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :items

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
  # rubocop:enable Lint/EmptyBlock
end
