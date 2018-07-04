Rails.application.routes.draw do
  resources :movies

  get 'play/:id', to: 'movies#show', as: 'play'

  root 'movies#index'
end
