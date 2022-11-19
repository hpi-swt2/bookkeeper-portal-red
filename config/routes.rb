Rails.application.routes.draw do
  get "items/:id/download", to: 'items#download', as: :download
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :groups
  resources :items do
    patch :update_lending
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
end
