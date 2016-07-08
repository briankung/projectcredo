Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers
  resources :lists

  resources :pins, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
