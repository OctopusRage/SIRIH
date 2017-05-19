Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :test, to: "test#index"
  namespace :v1 do
    resources :auth, controller: :auth, only: [:create]
    resources :registration, controller: :index, only: [:index]
  end
end
