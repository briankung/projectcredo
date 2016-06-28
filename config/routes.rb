Rails.application.routes.draw do
  root to: 'homepage#show'
  resources :papers
  resources :lists
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
