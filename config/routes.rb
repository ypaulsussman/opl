# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'quotes#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :quotes
  resources :authors
  resources :users
end
