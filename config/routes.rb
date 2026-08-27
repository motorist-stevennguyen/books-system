Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      scope path: "admin", as: "admin" do
        resources :books, only: [:index, :create, :show, :update, :destroy]
        resources :categories, only: [:index, :create, :show, :update, :destroy]
        resources :authors, only: [:index, :create, :show, :update, :destroy]
        resources :users, only: [:index, :create, :show, :update, :destroy]
      end

      resources :books, only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :authors, only: [:index, :show]
      resources :register, only: [:create]

      get :status, to: "health#status"
      post :login, to: "sessions#login"
      get :logout, to: "sessions#logout"
      get :profile, to: "users#profile"
      # get "books/:id", to: "books#show"
      # get :history, to: "users#history"
      # get :books, to: "books#index"
      # get :authors, to: "authors#index"
      # get :categories, to: "categories#index"
      # get "categories/:id", to: "categories#show"

      # scope "/admin" do
      #   post :books, to: "books#create"
      #   patch "books/:id", to: "books#update"
      #   delete "books/:id", to: "books#destroy"

      #   post :categories, to: "categories#create"
      #   patch "categories/:id", to: "categories#update"
      #   delete "categories/:id", to: "categories#destroy"

      #   post :authors, to: "authors#create"
      #   patch "authors/:id", to: "authors#update"
      #   delete "authors/:id", to: "authors#destroy"
      # end
    end
  end
end
