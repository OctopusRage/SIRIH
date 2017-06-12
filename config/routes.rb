Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get :test, to: "test#index"
  namespace :v1 do
    resources :auth, controller: :auth, only: [:create]
    resources :rs_index, controller: :index, only: [:index]
    get "patient_entry" => "recapitulations#get_patient_entry"
    get "patient_out" => "recapitulations#get_patient_out"
    get "patient_out_room" => "recapitulations#get_patient_out_room"
    get "patient_enter_room" => "recapitulations#get_patient_enter_room"
    get "gbj" => "gbj#index"
    get "dashboard" => "dashboard#index"
    resources :doctors, only: [:index]
    resources :room_list, controller: :room_list, only: [:index, :show]
    resources :classes, controller: :room_classes, only: [:index, :show]
    resources :users, only: [:index, :show, :update, :destroy, :create]
    namespace :hospital do
      get "indicators" => "indicators#index"
    end
    namespace :rooms do
      get "indicators" => "indicators#index"
    end
  end
end
