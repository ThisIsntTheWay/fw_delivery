Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Generate a new controller: bin/rails generate controller <CTRLName> index --skip-routes

  # Defines the root path route ("/")
  # root "articles#index"

  resource :project

  get "/firmware", to: 'firmware#index'
  get "/firmware/new", to: 'firmware#new'
  post "/firmware/create", to: 'firmware#create'
end
