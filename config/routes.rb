Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: "health#status"
      post :register, to: "register#create"
      post :login, to: "sessions#login"
      get :logout, to: "sessions#logout"
      get :profile, to: "users#profile"
      get "books/:id", to: "books#show"
      get :history, to: "users#history"
      get :books, to: "books#index"
      patch "books/:id", to: "books#update"
      get :authors, to: "authors#index"
      get :categories, to: "categories#index"
      get "categories/:id", to: "categories#show"
      patch "categories/:id", to: "categories#update"
    end
  end
end
