Rails.application.routes.draw do
  get 'game/index'

  get 'play/:movieid', to: 'game#play', as: 'play'

  root 'game#index'
end
