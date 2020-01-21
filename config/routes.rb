# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect('/quotes')

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :authors, param: :slug
  resources :users, except: [:show], param: :slug
  resources :quotes, except: [:show], param: :slug
end
