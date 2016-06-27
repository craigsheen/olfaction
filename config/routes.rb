Rails.application.routes.draw do
  resources :pull_requests, only: [:create, :index]

  root 'pull_requests#index'
end
