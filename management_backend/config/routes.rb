require 'sidekiq/web'

Rails.application.routes.draw do
  defaults format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 'token_auth/sessions' }

    get :statistics, to: 'statistics#show'

    resources :channels, except: %i(edit new destroy)
    resources :songs
    resources :playlists, except: %i(edit new) do
      put :player, to: 'players#update'
      delete :player, to: 'players#destroy'
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
