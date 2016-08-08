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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
