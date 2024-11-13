# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :activities do
        resources :locations
        resources :temp_users do
          member do
            post :convert_to_user
          end
        end
      end

      resources :check_ins, only: %i[create index]
      resources :rewards, only: %i[index show]
      resources :users, only: %i[create show update]
    end

    namespace :admin do
      resources :activities, only: %i[index show update]
    end
  end
end
