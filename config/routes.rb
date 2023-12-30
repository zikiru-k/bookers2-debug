Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "/home/about", to: "homes#about"
  get "/search", to: "searches#search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create,:destroy]
  end

  resources :users, only: [:index,:show,:edit,:create,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'posts_on_date' => 'users#posts_on_date'
  end

  resources :chats, only: [:show, :create, :destroy]
  resources :groups, only: [:index, :show, :new, :create, :edit, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end