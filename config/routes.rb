Rails.application.routes.draw do
  root 'players#new'
  get 'log_in' => 'sessions#new', as: 'login'
  get 'sign_up' => 'players#new', as: 'signup'
  get 'search/:action' => 'searches#:action',:defaults => { :format => 'json' }
  get 'sign_out' => 'sessions#destroy', as: 'signout'
  get 'nuke_games' => 'util#nuke_games'
  get 'nuke_sessions' => 'util#nuke_sessions'
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
