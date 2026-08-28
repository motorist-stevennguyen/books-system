Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      scope path: "admin", as: "admin" do
        resources :books, only: [ :index, :create, :show, :update, :destroy ] do
           collection do
            get :growth, action: :growth
            get :chart, action: :chart
            delete "", action: :destroy_many
          end
        end
        resources :categories, only: [ :index, :create, :show, :update, :destroy ]
        resources :authors, only: [ :index, :create, :show, :update, :destroy ]
        resources :users, only: [ :index, :create, :show, :update, :destroy ] do
          collection do
            get :growth, to: "users#growth"
            get :chart, to: "users#chart"
          end
        end
        resources :history, path: "book-views" do
          collection do
            get :growth, to: "history#growth"
            get :chart, to: "history#chart"
          end
        end
      end

      resources :register, only: [ :create ]
      resources :sessions, path: "auth" do
        collection do
          post :login, action: :create
          post :logout, action: :destroy
        end
      end
      resources :users, path: "me" do
        collection do
          get :profile, action: :profile
          patch :profile, action: :update_profile
          post :disabled, action: :disabled
        end
      end
      resources :books, only: [ :index, :show ]
      resources :categories, only: [ :index, :show ]
      resources :authors, only: [ :index, :show ]
      resources :history, only: [ :index, :destroy, :show ] do
        collection do
          delete "", action: :destroy_all
        end
      end

      get :status, to: "health#status"
    end
  end
end
