Rails.application.routes.draw do
  devise_for :users
  root 'homepage#show'
  resources :papers
  resources :lists

  post 'homepages_lists/:list_id', to: 'homepages_lists#create', as: 'homepages_list'
  delete 'homepages_lists/:list_id', to: 'homepages_lists#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
