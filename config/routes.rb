Rails.application.routes.draw do
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update] 
  resources :relationships, only: [:create, :destroy]
  
  resources :books do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  root to: 'home#top'
  get 'home/about'
  get 'users/:id/follows', to: 'users#follows', as: 'user_follows_index'
  get 'users/:id/followers', to: 'users#followers', as: 'user_followers_index'
  
end