Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  # override clearance/passwords#create
  post "passwords" => "passwords#create", as: :passwords

  resources :customers
  resources :asset_settings
  resources :branches
  resources :expenses, only: [ :index, :create, :show, :destroy ]
  resources :incomes, only: [ :index, :create, :show, :destroy ]

  resources :interest_calculation_methods, only: [ :show ]
  resources :wards, only: [ :index ]
  resources :staffs
  resources :cash_controls, only: [ :index ] do
    collection do
      post :deposit                 # Cho hành động Nhập quỹ
      post :update_opening_balance  # Cho hành động Nhập tiền đầu ngày
    end
  end

  resources :alerts, only: [ :create ]
  resource :current_tenant, only: [ :update ], controller: "current_tenant"

  # For contracts management
  namespace :contracts do
    resources :capitals
    resources :pawns
    resources :installments
    resources :interest_payments, only: [ :update ]
    resources :custom_interest_payments, only: [ :create, :show ]
    resources :reduce_principals, only: [ :update, :destroy ]
    resources :additional_loans, only: [ :update, :destroy ]
    resources :extend_terms, only: [ :update ]
    resources :withdraw_principals, only: [ :update, :show ]
    resources :asset_attributes, only: [ :show ]
    resources :debts, only: [ :create, :destroy ]
    resources :files, only: [ :create, :destroy ]
    resources :reminders, only: [ :index, :create, :destroy ]
  end

  # For customers management
  namespace :customers do
    resources :files, only: [ :create, :destroy ]
  end

  namespace :pdfs do
    resources :contracts, only: [ :create, :show ]
    resources :interest_payments, only: [ :show ]
  end

  # For automplete search
  namespace :autocomplete do
    resources :customers, only: [ :index, :show ]
  end
end
