Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: "health#status"
      post :register, to: "register#create"
      post :login, to: "sessions#login"
      post :logout, to: "sessions#logout"
      get :profile, to: "users#profile"
      get "books/:id", to: "books#show"
      get :history, to: "users#history"
    end
  end
end
