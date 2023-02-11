Rails.application.routes.draw do
  resources :pics
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'signup', to: "users#new"
  post 'signedup', to: "users#create"
  root  to: 'users#index'


  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'cars', to: 'cars#index'
  resources :users, only: [:edit, :update]
  resources :cars, only: [:show, :index, :new, :create, :edit, :update]
 
  
end
