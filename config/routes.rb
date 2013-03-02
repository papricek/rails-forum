RailsForum::Application.routes.draw do

  devise_for :users

  root :to => "forums#index"

  resources :forums, :only => [:index, :show] do
    resources :topics do
      member do
        get :subscribe
        get :unsubscribe
      end
    end
  end

  match "/:forum_id/:id" => "topics#show", via: :get, as: 'forum_topic'
  match "/:id" => "forums#show", via: :get, as: 'forum'

  resources :categories, :only => [:index, :show]

end
