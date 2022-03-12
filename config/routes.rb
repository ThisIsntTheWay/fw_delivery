Rails.application.routes.draw do
  root 'firmwares#index'

  resources :firmwares
  resources :repository, only: [:index, :new]

  # GET
  get "/firmware", to: "firmwares#index"
  get "/firmware/new", to: "firmwares#new"

  get "/repository/:id", to: "repository#manage"
  get "/repository/:id/objects", to: "repository#manage_objects"

  # POST
  post "/repository/create"
  post "/firmware/create", to: "firmwares#create"

  # DELETE
  delete "/repository/:id", to: "repository#delete"
  delete "/firmware/:id", to: "firmwares#destroy"
end