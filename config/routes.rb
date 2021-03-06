Rails.application.routes.draw do
  
  if Rails.env.development?
    authenticate :user do
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end
  end
  post "/graphql", to: "graphql#execute"
  
  mount ActionCable.server => '/cable'
 
  namespace :admin do
    resources :users
    resources :comments
    resources :orders
    resources :products

    root to: "users#index"
  end
  
  # rerouting the landing page
  root 'simple_pages#landing_page'
  
  get 'simple_pages/contact'
  get 'simple_pages/about'
  get 'simple_pages/cart'
  get '/after_confirmation', to: 'users#after_confirmation'
  get 'payments/after', as: 'after_payments'

  post 'simple_pages/thank_you'
  post 'orders/create', as: 'create_order'
  post 'payments/create', as: 'payments'
  post 'request_admin_rights', to: 'users#request_admin_rights'

  resources :products do
    resources :comments
  end

  resources :users
  resources :orders, only:[:index, :destroy]

  namespace :api do 
    namespace :v1 do 
      resources :carts, only:[:index, :create, :destroy]
      resources :products, only:[:index, :show]
      get '/userinfo', to: 'userinfos#is_admin'
    end
  end
  
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' },
        controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }
end
