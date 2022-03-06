Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Generate a new controller: bin/rails generate controller <CTRLName> index --skip-routes

  # Defines the root path route ("/")
  # root "articles#index"

  root 'firmware#index'

  resource :project

  # GET
  get "/firmware", to: 'firmware#index'
  get "/firmware/new", to: 'firmware#new'

  get "/repository", to: "repository#index"
  get "/repository/new", to: "repository#new"
  get "/repository/:id", to: "repository#manage"
  get "/repository/:id/objects", to: "repository#manage_objects"

  # POST
  post "/firmware/create"
  post "/repository/create"

  # DELETE
  delete "/repository/:id", to: "repository#delete"
end
