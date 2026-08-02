Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "rooms#search"

  resources :rooms, only: [:index, :show, :new, :create] do
    collection do
      get :search
    end
  end

  resources :reservations, only: [:index, :create] do
    collection do
      get :new
      post :confirm
    end
  end

  resource :account, only: [:show], controller: "accounts"
  resource :profile, only: [:edit, :update], controller: "profiles"
end