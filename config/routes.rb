# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :activities do
      member do
        get :check_ins, to: 'activities#list_check_ins'
      end
      # resources :check_ins, only: %i[create index]
      resources :temp_users, only: [:create]
      resources :rewards, only: %i[index show update]
    end

    namespace :admin do
      resources :activities
      resources :locations
    end

    resources :locations, only: %i[index show]
    resources :check_ins do
      collection do
        get :index_with_activity
      end
    end
  end
end
