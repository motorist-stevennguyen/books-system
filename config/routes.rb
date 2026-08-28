Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      scope path: "admin", as: "admin" do
        resources :books, only: [ :index, :create, :show, :update, :destroy ]
        resources :categories, only: [ :index, :create, :show, :update, :destroy ]
        resources :authors, only: [ :index, :create, :show, :update, :destroy ]
        resources :users, only: [ :index, :create, :show, :update, :destroy ]

        get "dashboard/growth/user", to: "dashboard#user_growth"
        get "dashboard/chart/user", to: "dashboard#user_chart"
      end

      resources :books, only: [ :index, :show ]
      resources :categories, only: [ :index, :show ]
      resources :authors, only: [ :index, :show ]
      resources :register, only: [ :create ]
      resources :history, only: [:index, :destroy]

      get :status, to: "health#status"
      get :profile, to: "users#profile"
      patch :profile, to: "users#update_profile"
      delete :history, to: "history#destroy_all"

      post :login, to: "sessions#create"
      get :logout, to: "sessions#destroy"
    end
  end
end
