Rails.application.routes.draw do
  # Root path
  root "landing#index"

  # Devise user authentication with Omniauth callbacks
 # Devise user authentication with Omniauth
devise_for :users, controllers: {
  omniauth_callbacks: "users/omniauth_callbacks"
}


  # Static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  # Reservations
  resources :reservations, only: [:index]

  # Categories
  resources :categories

  # Foods with nested reviews
  resources :foods do
    resources :reviews, only: [:create]
  end

  # Drinks & Small Chops
  resources :drinks, only: [:index, :show]
  resources :small_chops, only: [:index, :show]

  # Orders
  resources :orders, only: [:new, :create, :show, :index] do
    collection do
      get :export_csv
    end
    member do
      get :message_admin
      get :download_summary, to: "orders#download_summary"
    end
  end

  # Checkout & Cart
  resource :checkout, only: [:show, :create]
  resource :cart, only: [:show] do
    post 'add_item/:id', to: 'carts#add_item', as: :add_item
    delete 'remove_item/:id', to: 'carts#remove_item', as: :remove_item
    get 'checkout', to: 'carts#checkout', as: :checkout
  end
  resources :cart_items, only: [:create, :update, :destroy]

  # Payment
  post 'paystack/checkout', to: 'payments#pay', as: :paystack_checkout
  get "/verify", to: "payments#verify", as: "verify_payment"

  # Admin namespace
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'

    resources :users, only: [:index, :show, :destroy]
    resources :categories
    resources :foods do
      resources :reviews, only: [:create]
    end
    resources :orders, only: [:index, :show, :update] do
      member do
        patch :mark_paid
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Dev only
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
