Rails.application.routes.draw do




  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
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

  get '*id', :to => 'spree/taxons#show', :as => :categories
  
end

Spree::Core::Engine.routes.draw do
  get "/contact" => "home#contact"
  get "/about_us" => "home#about_us"
  post "/messages" => "home#createMessage"
  get "/new_message" => "home#newMessage"
  get "/download/:product_id/:variant_id" => "home#downloadFile", as: "public_download_product_file"

  get "/combos" => "combos#index"
  get "/combos/:combo_id" => "combos#ordenar_combo", as: :ordenar_combo
  
  resources :orders, except: [:index, :new, :create, :destroy] do
    post :populate, on: :collection
    post :populate_combos, on: :collection
  end

  namespace :admin , path: Spree.admin_path do
    get '/prices_files', to: 'price_file#index', as: :prices_files
    post '/prices_files', to: 'price_file#create', as: :create_prices_files
    post '/prices_files_confirm', to: 'price_file#confirm', as: :confirm_prices_files

    get '/stock_list', to: 'stock_list#index', as: :stock_list

    resources :users do
      member do
        put :confirmate
      end
    end

    resources :combos
    resources :products do
        get "/files" => "products#indexFile"
        get "/files/new" => "products#newFile"
        get "/files/:variant_id" => "products#downloadFile", as: "download_product_file"
        post "/files" => "products#createFile", as:"create_product_file"
        delete "/files/:variant_id" => "products#destroyFile", as:"delete_product_file"
    end
  end


end
