Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers, only: [:show, :edit, :update]

  resources :pins, only: [:create, :destroy]

  resources :lists do
    resources :references, only: [:show, :create, :destroy]
    resource :vote, controller: 'lists/votes', only: [:create, :destroy]
  end

  resources :references do
    resource :vote, controller: 'references/votes', only: [:create, :destroy]
  end

  resources :comments, only: [:create, :edit, :update, :destroy] do
    resource :vote, controller: 'comments/votes', only: [:create, :destroy]
  end

  get ':id' => 'users/lists#index', as: :user_profile
  get ':user_id/:id' => 'users/lists#show', as: :user_list
  get ':user_id/:list_id/:id' => 'users/references#show', as: :user_reference
end
