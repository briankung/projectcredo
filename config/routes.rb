Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers, only: [:show, :edit, :update]

  resources :pins, only: [:create, :destroy]

  resources :lists do
    member do
      resources :references, only: [:show, :create, :destroy]
      resource :vote, controller: 'lists/votes', only: [:create, :destroy], as: :list_vote
    end
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
end
