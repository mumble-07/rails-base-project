require 'resque/server'

Rails.application.routes.draw do
  devise_for :admins, path: 'admins', skip: [:registrations, :passwords]
  devise_for :users, path: 'users'
  resources :static_pages
  resources :users do 
    resources :portfolios, only: [:new, :create]
  end
  
  # resources :admins #removed resources for admins

  root 'static_pages#home_page'
  
  resources :markets, only: [:index]
  resources :histories, only: [:index]

  
  authenticated :admin do
    #admin specific routes
    get '/admins/trader-settings', to: 'admins#trader_settings' #list view of users
    get '/admins/approvals', to: 'admins#approvals' #view to approve users
    put '/admins/approvals', to: 'admins#approve_account'
    get '/admins/add_user', to: 'admins#add_user'
    post '/admins/add_user', to: 'admins#create_user'
    get '/admins/trader-settings/:id', to: 'admins#show_user', as: :user_profile
    put '/admins/trader-settings/:id', to: 'admins#modify_user'
    patch '/admins/trader-settings/:id', to: 'admins#modify_user'
    get '/admins/trader-settings/:id/edit', to: 'admins#edit_user', as: :edit_user_profile
    #resque FE
    mount Resque::Server.new, at: '/admins/jobs'
  end
end
