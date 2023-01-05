Rails.application.routes.draw do
  get "items/:id/download", to: 'items#download', as: :download

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :groups, except: [:show, :new] do
    post :leave
  end
  resources :items do
    patch :update_lending
    collection do
      get "/my", to: "items#my_items", as: :my
      get "/my/borrowed", to: "items#mine_borrowed", as: :mine_borrowed
      get "/borrowed", to: "items#borrowed_by_me", as: :borrowed_by_me
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

  # QR-Code Scan site
  get '/scan', to: 'qr_reader#scan'

  delete "/notifications/:id", to: "notifications#destroy"
end
