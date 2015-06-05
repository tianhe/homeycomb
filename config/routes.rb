require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { :omniauth_callbacks => "web/omniauth_callbacks" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', as: :logout
  end

  namespace :v1, defaults: { format: :json } do
    resources :users,           only: [:update, :show]
    resources :authentications, only: [:create]
  end

  namespace :web do
    resources :user_listings,           only: [:index]
  end
  # You can have the root of your site routed with "root"
  root 'welcome#index'
end
