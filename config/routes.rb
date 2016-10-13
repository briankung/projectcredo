Rails.application.routes.draw do
  # Web application routes
  # Resources: Users, Papers, Lists, References, Comments
  # Non-REST actions: Pins, Votes
  #
  # Top level:
  # - Lists (New, Create)
  # - Papers
  # - Users
  #   Lists (Pins, Votes)
  #     References (Votes)
  #       Comments (Votes)
  #
  # Example path:
  # /username/list-name/reference_id/comment_id/unvote
  #
  # Example URL:
  # https://www.projectcredo.com/briankung/maintaining-mobility-in-old-age/12345/6789/unvote

  root 'homepage#show'

  devise_for :users

  resources :lists, only: [:new, :create]

  resources :papers, only: [:show, :edit, :update]

  resources :user, path: '/', only: :show do
    resources :lists, except: [:new, :create], path: '/' do
      post 'pin'
      post 'unpin'
      post 'vote'
      post 'unvote'

      resources :references, path: '/', only: [:show, :create, :destroy] do
        post 'vote'
        post 'unvote'
        resources :comments, path: '/', only: [:edit, :create, :update, :destroy] do
          post 'vote'
          post 'unvote'
        end
      end
    end
  end
end

