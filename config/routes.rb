Rails.application.routes.draw do
  # Root path
  root "landing#index"

  # Devise user authentication
  devise_for :users

  # Public resources
  resources :categories, only: [:index, :new, :create, :show, :edit, :destroy]

  # Foods with nested reviews (public site)
  resources :foods, only: [:index, :new, :create, :edit, :show, :update, :destroy] do
    resources :reviews, only: [:create]   # <-- Add this here for public reviews
  end

  resources :orders, only: [:new, :create, :show, :index] do
    collection do
      get :export_csv
    end
  end

  resource :checkout, only: [:show, :create]

  resource :cart, only: [:show] do
    post 'add_item/:id', to: 'carts#add_item', as: :add_item
    delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item
    get 'checkout', to: 'carts#checkout', as: :checkout
  end

  resources :cart_items, only: [:create, :update, :destroy]

  # Custom order routes
  post "/orders/:id/message_admin", to: "orders#message_admin", as: :message_admin

  # Payment routes
  post 'paystack/checkout', to: 'payments#pay', as: :paystack_checkout
  get "/verify", to: "payments#verify", as: "verify_payment"

  # Admin namespace
  namespace :admin do
    # Dashboard
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'

    # Users management
    resources :users, only: [:index, :show, :destroy]

    # Categories, Foods with nested reviews (admin)
    resources :categories
    resources :foods do
      resources :reviews, only: [:create]
    end

    # Orders with custom member route
    resources :orders, only: [:index, :show, :update] do
      member do
        patch :mark_paid
      end
    end
  end

  resources :orders do
  member do
    get :message_admin
  end
end

get 'orders/:id/download_summary', to: 'orders#download_summary', as: 'download_order_summary'


  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Development only
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
