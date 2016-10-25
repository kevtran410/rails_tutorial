Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resource :account_activations, only: [:edit, :update]
  resource :password_resets, except: [:destroy, :show]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:index, :create, :destroy]
end
