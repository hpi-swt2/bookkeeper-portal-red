Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  
  root "landing_page#index"
  match 'lang/:locale', to: 'index#change_locale', as: :change_locale, via: [:get]
  resources :items
  devise_for :users
  
  # scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
  # # https://github.com/heartcombo/devise/blob/main/README.md
  # end
end
