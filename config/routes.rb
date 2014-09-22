Rails.application.routes.draw do
  root 'games#index'
  get 'log_in' => 'sessions#log_in', as: 'login'
  get 'sign_up' => 'players#new', as: 'signup'
  resources :games
  resources :players  
end
