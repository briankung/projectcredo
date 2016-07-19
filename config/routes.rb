Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers do
    collection do
      get 'search'
    end
  end

  resources :pins, only: [:create, :destroy]

  resources :lists do
    member do
      resources :references, only: [:create, :destroy]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
