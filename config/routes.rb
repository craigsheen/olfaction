Rails.application.routes.draw do
  resources :pull_requests, only: [:create]

  root 'pages#index'
end
