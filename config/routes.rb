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
  get '/' => 'categories#show', :defaults => { category_id: "16" }

  get "/contact" => "home#contact"
  get "/about_us" => "home#about_us"
  get "/help" => "home#help"
  get "/descargas" => "home#descargas"
  post "/messages" => "home#createMessage"
  get "/new_message" => "home#newMessage"
  get "/download/:product_id/:variant_id" => "home#downloadFile", as: "public_download_product_file"
  get "/decarga/static/:file_id" => "home#publicDownload", as: "download_static_file"

  get "/combos" => "combos#index"
  get "/mercado_libre" => "combos#mercado_libre", as: :mercado_libre
  get "/mercado_libre/:combo_id" => "combos#mercado_libre_combo", as: :mercado_libre_combo
  get "/combos/combo_compuesto/:combo_string" => "combos#ordenar_combo_compuesto", as: :ordenar_combo_compuesto
  get "/combos/:combo_id" => "combos#ordenar_combo", as: :ordenar_combo
  get "/categories_combos/:category_id" => "categories#show"
  get "/downloadable_files/:id" => "downloadable_files#download", as: :downloadable_files_download
  

  get "/combo_order_checkout/:order_id/address" => "combo_order_checkout#address", as: :combo_order_checkout_address
  patch "/combo_order_checkout/:order_id/address" => "combo_order_checkout#address_update", as: :combo_order_checkout_address_update
  get "/combo_order_checkout/:order_id/metodo_envio" => "combo_order_checkout#metodo_envio", as: :combo_order_checkout_metodo_envio
  patch "/combo_order_checkout/:order_id/metodo_envio" => "combo_order_checkout#metodo_envio_update", as: :combo_order_checkout_metodo_envio_update
  get "/combo_order_checkout/:order_id/forma_de_pago" => "combo_order_checkout#forma_de_pago", as: :combo_order_checkout_forma_de_pago
  patch "/combo_order_checkout/:order_id/forma_de_pago" => "combo_order_checkout#forma_de_pago_update", as: :combo_order_checkout_forma_de_pago_update
  get "/combo_order_checkout/:order_id/redirect_mercadopago" => "combo_order_checkout#redirect_mercadopago", as: :combo_order_checkout_redirect_mercadopago

  get "/combo_order_checkout/:order_id/payment_return" => "combo_order_checkout#payment_return", as: :payment_return

  get "/combos/:combo_id/seleccionar_cantidad" => "combos#seleccionar_cantidad", as: :combo_seleccionar_cantidad


  resources :orders, except: [:index, :new, :create, :destroy] do
    post :populate, on: :collection
    post :populate_combos, on: :collection
    # post :populate_multiple_combos, on: :collection
    post :register_ml, on: :collection
    post :register_ml_combo, on: :collection
    delete :remove_combo_aplicado, on: :collection
  end


  namespace :admin , path: Spree.admin_path do
    get '/prices_files', to: 'price_file#index', as: :prices_files
    post '/prices_files', to: 'price_file#create', as: :create_prices_files
    post '/prices_files_confirm', to: 'price_file#confirm', as: :confirm_prices_files

    get '/stock_list', to: 'stock_list#index', as: :stock_list

    get '/taxon_video', to: 'taxon_video#index'
    post '/taxon_video', to: 'taxon_video#create', as: :videos
    delete '/taxon_video/:id', to: 'taxon_video#destroy', as: :delete_video

    get '/customize_emails', to: 'customize_emails#index'
    put '/customize_emails/update', to: 'customize_emails#update'

    get '/eventualities', to: 'eventualities#index'
    post '/eventualities', to: 'eventualities#create', as: :create_eventualities
    put '/eventualities/:id', to: 'eventualities#update', as: :update_eventualities
    delete '/eventualities/:id', to: 'eventualities#destroy', as: :delete_eventualities

    get '/configure_help', to: 'configure_help#index'
    put '/configure_help/update', to: 'configure_help#update'

    get '/configure_download', to: 'configure_download#index'
    put '/configure_download/update', to: 'configure_download#update'

    resources :orders, except: [:show] do
      member do
        post :send_presupuesto
        post :set_as_notified
        post :set_as_delivered
        post :set_as_pending
      end
    end

    resources :users do
      member do
        put :confirmate
      end
    end

    resources :complements

    resources :downloadable_files
    
    resources :combos do
      member do
        post :clone_combo
      end
    end
    resources :products do
      collection do
        get :ordenar_productos
        post :update_positions
      end
        get "/files" => "products#indexFile"
        get "/files/new" => "products#newFile"
        get "/files/:variant_id" => "products#downloadFile", as: "download_product_file"
        post "/files" => "products#createFile", as:"create_product_file"
        delete "/files/:variant_id" => "products#destroyFile", as:"delete_product_file"
    end

    resources :categories do
      collection do
        post :sort
      end
    end

  end

  get '/index.html', to: redirect('/', status: 301)
  get '/index.htm', to: redirect('/', status: 301)
  get '/index_archivos/pooles/frame_pooles.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/frame_flippers_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/gomas.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/frame_flippers_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/frame_flippers_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/la_empresa.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/enlaces.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/resortes_flipper.htm', to: redirect('/', status: 301)
  get '/index_archivos/manejo/frame_manejo.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/regaton_flipper.htm', to: redirect('/', status: 301)
  get '/index_archivos/tejo/frame_tejo.htm', to: redirect('/', status: 301)
  get '/index_archivos/capsulas/frame_capsulas.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/frame_video_%20juegos.htm', to: redirect('/', status: 301)
  get '/index_archivos/metegoles/frame_metegoles.htm', to: redirect('/', status: 301)
  get '/index_archivos/bobinas/bobinas.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/boton_leng.htm', to: redirect('/', status: 301)
  get '/index_archivos/varios/frame_varios.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/tirabola_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/manejo/engranaje_day_2.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/fichas.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/porta_plaquetas.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/gomas_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/pooles/culatas.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/balancines_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lenguetas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/escuadras_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/microswitch_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/index2_archivos/arriba2.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_flipper_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/cerradura_tubular_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/boton_redondo.htm', to: redirect('/', status: 301)
  get '/index_archivos/pooles/bolas.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/cerradura_tubular_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/metegoles/metegol_a3.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/comandos_micros_archivos/C2.pdf', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pateadores_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/postes_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lenguetas_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/optos_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/minimicros_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/coil_stop_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pasillos_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pivots_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/plungers_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bujes_bob_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/resortes_flipper_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_y_pasaficha_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/tirabola_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/tornillos_etc_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_flipper_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boquillas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bolas_flipper_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/fichas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bujes_pateadores_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/fusibles_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/gomas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/kit_escuadras_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/enlaces_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lamparitas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/kit_lenguetas_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/regaton_flipper_d.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/regaton_flipper_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/cerradura_tubular.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/plungers_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/escuadras_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/manejo/resortes_pedalera_happ.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/kit_lenguetas_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_flipper.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/minimicros_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/postes_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bujes_bob_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bolas_flipper_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/regaton_flipper_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/despiece_c2.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_y_pasaficha.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/tirabola.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lamparitas_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/manejo/engranaje_day_1.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/microswitch_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bujes_pateadores_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/fichas_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lenguetas.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/minimicros_a.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/despiece_b1.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/balancines_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boquillas_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/escuadras_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/coil_stop_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/bujes_pateadores_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_flipper_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/fusibles_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/gomas_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/resortes_flipper_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/plungers_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pivots_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pateadores_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/lamparitas_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/pasillos_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/optos_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/microswitch_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/comandos_micros.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/kit_tornillos.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/micros_video.htm', to: redirect('/', status: 301)
  get '/index_archivos/metegoles/metegol_ene.htm', to: redirect('/', status: 301)
  get '/index_archivos/pooles/salidas_bola.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/boquillas.htm', to: redirect('/', status: 301)
  get '/index_archivos/video_juegos/comandos_leng.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/tirabola_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/flippers/boton_y_pasaficha_da.htm', to: redirect('/', status: 301)
  get '/index_archivos/pooles/cerradura_tubular.htm', to: redirect('/', status: 301)



end
