Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts, only: [:new, :create, :index]
  root 'posts#index'
  resources :sessions, only: [:new, :create, :destroy]
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signin',  to: 'sessions#create',         via: 'post'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
