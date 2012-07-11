Classy::Application.routes.draw do
  get "password_resets/new"

  get "user_profile/new"

  get "user_profile/update"

  get "user_profile/create"

  get "group_applications/create"

  get "group_applications/destroy"

  get "group_members/create"

  get "group_members/destroy"

  get "group_members/update"

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :blurts, only: [:create, :destroy]
  resources :posts, except: [:new] do #new post is handled through the :groups resource
    resources :comments
  end
  resources :friendships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  resources :groups do
    resources :posts, only: [:new]
    collection do
      get 'all', as: 'all'
      put 'toggle_status/:id' => 'groups#toggle_status', as: 'toggle_status'
    end
  end

  resources :group_applications, only: [:create, :destroy]
  resources :group_members, only: [:create, :destroy, :update]

  resources :admin, only: [:index]

  resources :tags, only: [:create, :index, :show]

  resources :user_profiles, only: [:new, :create, :update, :edit]

  resources :password_resets

  root :to => "dashboard#home"
  
  match '/help',    to: 'dashboard#help'
  match '/about',   to: 'dashboard#about'
  match '/contact', to: 'dashboard#contact'

  match '/search', to: 'search#index', as: 'search', via: 'POST'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
end
