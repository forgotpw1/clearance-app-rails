Rails.application.routes.draw do
  resources :clearance_batches, only: [:index, :create, :show, :destroy]
  resources :items, only: [:index, :update]
  root to: "clearance#index"
end
