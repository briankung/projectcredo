Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers

  resources :pins, only: [:create, :destroy]

  resources :lists do
    member do
      resources :references, only: [:create, :destroy]
      resource :vote, only: [:create, :destroy], as: :list_vote
    end
  end

  namespace :reference do
    scope ":id" do
      post 'vote' => 'votes#create', as: :vote
      delete 'vote' => 'votes#destroy'

      resources :comments, only: [:edit, :create, :update, :destroy]
    end
  end
end
