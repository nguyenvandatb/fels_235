Rails.application.routes.draw do
  root "static_pages#home"
  get "about" => "static_pages#about"
  get "help" => "static_pages#help"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
end
