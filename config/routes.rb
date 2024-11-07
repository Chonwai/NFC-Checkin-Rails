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
      
      resources :check_ins, only: [:create, :index]
      resources :rewards, only: [:index, :show]
      resources :users, only: [:create, :show, :update]
    end
  end
end
