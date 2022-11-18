Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :groups

  # https://github.com/heartcombo/devise/blob/main/README.md
  devise_for :users

  # Defines the root path route ("/")
  root "landing_page#index"
end
