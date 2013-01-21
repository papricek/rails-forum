RailsForum::Application.routes.draw do

  mount Forem::Engine, :at => '/'

  devise_for :users

  #root :to => 'welcome#index'

end
