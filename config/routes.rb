Coblogger::Application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :blurts, only: [:create, :destroy]
  resources :posts do
    resources :comments
  end
  resources :friendships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  resources :groups

  root :to => "dashboard#home"
  match '/help',    to: 'dashboard#help'
  match '/about',   to: 'dashboard#about'
  match '/contact', to: 'dashboard#contact'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
end
