# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', action: :index, controller: 'quotes'
  get '/signup', to: 'users#new'
  resources :quotes
  resources :authors
  resources :users
end
