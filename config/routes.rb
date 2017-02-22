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
  resources :follower, only: :show
  resources :following, only: :show
  resources :password_resets, except: [:index, :show, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :categories, only: :index
  resources :lessons
  resources :words, only: :index
  namespace :admin do
    root "admins#index", as: :root
    resources :words
    resources :categories
    resources :users
    resources :words do
      delete :destroy, on: :collection
    end
  end
  resources :categories do
    resources :lessons do
      member do
        get "test", to: "tests#show"
        patch "result", to: "results#show"
        get "result", to: "results#show"
      end
    end
  end
end
