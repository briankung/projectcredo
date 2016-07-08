Rails.application.routes.draw do
  root 'homepage#show'

  devise_for :users

  resources :papers
  resources :lists

  post 'pins/:list_id', to: 'pins#create', as: 'pins'
  delete 'pins/:list_id', to: 'pins#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
