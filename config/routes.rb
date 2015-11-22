Rails.application.routes.draw do

  # Api definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1 do
      # We are going to list our resources here
    end
  end

  get 'addresses/new'

  get 'addresses/create'

  get 'stores/index'

  get 'products/show'

  get 'products/index'

  get 'stores/find_stores'

  get 'products/find_products'

  get 'store_products/find_store_products'

  get 'stores/find_nearest_stores'

  get 'store_products/find_more_valuable_products'

  get 'store_products/find_store_product_withs_ids'

  patch 'sale_store/update_with_status'

  post 'stores/update_column_active'
  patch 'stores/update_column_active'

  patch 'stores/update_email'
  patch 'stores/update_password'
  patch 'stores/update_infos_of_stores'
  patch 'stores/update_forms_of_payments_of_store'
  patch 'stores/update_address_of_store'

  get 'sale_client/update_with_status'
  get 'apresentation/fale_conosco'
  get 'product_suggestions/index_suggestions_of_store'
  patch 'product_suggestions/update_with_status'

  devise_for :admins, controllers: { registrations: "admins/registrations" }

  #devise_for :clients
  devise_for :clients, :skip => [:sessions, :registrations, :confirmations, :omniauth_callbacks, :passwords, :unlocks]
  devise_for :stores, controllers: { registrations: "stores/registrations", sessions: "stores/sessions" }

  resources :sales, :only => [:show, :index]
  resources :stores, :only => [:show, :index, :create, :update, :destroy]
  resources :store_active_or_disable, :only => [:index, :edit, :update]
  resources :stores_sessions, :only => [:create, :destroy]
  resources :clients, :only => [:show, :index, :create, :update, :destroy]
  resources :clients_sessions, :only => [:create, :destroy]
  resources :products
  resources :store_products
  resources :on_sale_percentages
  resources :addresses, :path => 'addresses'
  resources :form_of_payment_of_store
  resources :client_addresses, :only => [:index, :create, :update, :destroy]
  resources :sale_products, :only => [:index]
  resources :sale_client, :only => [:index, :create, :update]
  resources :sale_store, :only => [:index, :show]
  resources :product_suggestions
  # resources :apresentation, :only => [:index]
  
  root 'products#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
