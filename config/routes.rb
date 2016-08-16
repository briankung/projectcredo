Rails.application.routes.draw do
  if Rails.env.development?
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
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

  post 'references/:id/vote' => 'votes#create', as: :reference_vote
  delete 'references/:id/vote' => 'votes#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
