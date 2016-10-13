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
    member do
      resource :vote, controller: 'references/votes', only: [:create, :destroy], as: :reference_vote
      resources :comments, only: [:create, :update, :destroy]
    end
  end

  resources :comments, only: :edit do
    resource :vote, controller: 'comments/votes', only: [:create, :destroy]
  end

  get ':username' => 'users/lists#index', as: :user_profile
  get ':username/:list_slug' => 'users/lists#show', as: :user_list
  get ':username/:list_slug/:reference_id' => 'users/references#show', as: :user_reference
end
