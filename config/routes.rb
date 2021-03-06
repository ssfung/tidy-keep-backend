# frozen_string_literal: true

Rails.application.routes.draw do
  # This create action is setup by knock we get it through the inheritance from the auth_token_controller
  resources :services
  post '/login', to: 'user_token#create'
  get '/status', to: 'status#index'
  get '/status/user', to: 'status#user'

  # create new user
  post '/sign-up', to: 'users#create'

  resources :bookings
  resources :addresses
  resources :booking_service, only: %i[create]
  resources :invoices
  get '/payments/session', to: 'payments#get_stripe_id'
  post '/payments/webhook', to: 'payments#webhook'
  post '/booking_service', to: 'bookingservice#create'
end
