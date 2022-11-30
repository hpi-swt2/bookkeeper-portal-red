Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :items do
    patch :update_lending
  end

  devise_for :users
  # Defines the root path route ("/")
  root "landing_page#index"

  # Profile routes
  get "/profiles/me", to: "profiles#show_me"
  get "/profiles/:id", to: "profiles#show", as: :profile

  # rubocop:todo Lint/EmptyBlock
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  end
  # rubocop:enable Lint/EmptyBlock
end
