Socialthingamajig::Application.routes.draw do

  resources :users do
    resources :friend_circles
    resources :posts, only: [:show, :new, :create] do
      resources :links
    end
  end
  resource :session
  get '/feed', to: 'users#index'

end
