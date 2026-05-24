Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  namespace :manager do
    resources :orders, only: [ :index, :new, :create, :show, :update ]
  end

  namespace :rider do
    resources :orders, only: [ :index, :show, :update ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
