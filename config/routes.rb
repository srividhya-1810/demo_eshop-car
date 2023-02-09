Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'signup', to: "users#new"
  post 'signedup', to: "users#create"
  get 'index', to: 'users#index'
end
