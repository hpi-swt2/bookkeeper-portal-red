Rails.application.routes.draw do
  get "items/:id/download", to: 'items#download', as: :download
  get '/items/:id/permissions', to: 'items#permissions'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :groups, except: [ :new ] do
    post :leave
    patch :add_user, to: "memberships#add_user"
    patch :remove_user, to: "memberships#remove_user"
    collection do
      get '/all', to: 'groups#all'
    end
  end

  resources :items do
    patch :reserve
    patch :borrow
    patch :give_back
    patch :update_lending
    patch :join_waitlist
    patch :leave_waitlist
    patch :toggle_status
    collection do
      get "/my", to: "items#my_items", as: :my
      get "/my/borrowed", to: "items#mine_borrowed", as: :mine_borrowed
      get "/borrowed", to: "items#borrowed_by_me", as: :borrowed_by_me
      get :export_csv
    end
    member do
      delete 'remove_image/:signed_id', to: 'items#remove_image', as: 'remove_image'
      post 'add_image', to: 'items#add_image', as: 'add_image'
      delete :delete_image_attachment
    end
  end

  # Add controllers for omniauth (openid connect)
  devise_for :users,
             controllers: {
               omniauth_callbacks: "users/omniauth_callbacks",
               sessions: "users/sessions",
               registrations: "registrations"
             }

  # Defines the root path route ("/")
  root "landing_page#index"
  # Defines home path route ("/home")
  get "/", to: "landing_page#index", as: :home

  # Profile routes
  get "/profiles/me", to: "profiles#show_me"
  get "/profiles/:id", to: "profiles#show", as: :profile
  get "/profiles/me/edit", to: "profiles#edit_me", as: :edit_profile

  # Analytics routes
  get '/analytics', to: 'analytics#show', as: :analytics

  # Development-only user switching code
  if Rails.env.development?
    get "/development/switch_user/:id", to: "development_tools#switch_user", as: :development_tools_switch_user
  end

  # QR-Code Scan site
  get '/scan', to: 'qr_reader#scan'

  # Notifications
  delete "/notifications/:id", to: "notifications#destroy"

  get "/notifications/", to: "notifications#all"

end
