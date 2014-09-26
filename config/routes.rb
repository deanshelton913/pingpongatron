Rails.application.routes.draw do
  root 'games#new'
  get 'log_in' => 'sessions#new', as: 'login'
  get 'sign_up' => 'players#new', as: 'signup'
  get 'search/:action' => 'searches#:action',:defaults => { :format => 'json' }
  resources :games do
    collection do
      get 'join'
      get 'current'
      get 'matchmaking'
    end
  end
  resources :players
  resources :sessions
end
