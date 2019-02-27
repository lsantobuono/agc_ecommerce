module Spree
  OrdersController.class_eval do 
    include ParserComboCompuesto

    # El unico motivo por el que pongo esto es para no redirigir al carrito, no deberia tocarse nada mas !!!
    def populate
      order    = current_order(create_order_if_necessary: true)
      
      #Valido que no exista previamente un combo ML
      if (!order.nil?)
        if (!order.ml_user.nil?)
          if (!order.combo_aplicados.first.nil?)
            flash[:error] = "No puede agregar items a un pedido de Mercado Libre"
            redirect_back_or_default(spree.root_path)
            return
          end
        end
      end

      variant  = Spree::Variant.find(params[:variant_id])
      quantity = params[:quantity].to_i
      options  = params[:options] || {}

      # 2,147,483,647 is crazy. See issue #2695.
      if quantity.between?(1, 2_147_483_647)
        begin
          order.contents.add(variant, quantity, options)
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.full_messages.join(", ")
        end
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else
        flash[:info] = Spree.t(:product_added)
        redirect_back_or_default(spree.root_path)

#        redirect_to spree.root_path        
       # respond_with(order) do |format|
          #format.html { redirect_to cart_path }
       # end
      end
    end

    def register_ml
      order = current_order(create_order_if_necessary: true)
      order.empty! #Las vacío sin importar que tengan, porque al agregarse un combo de ML solo debe haber combos de ML

      order.ml_user = params[:ml_user]
      order.ml_purchase_id = params[:ml_purchase_id]

      if (params[:ml_user] == "")
        flash[:error] = "Por favor ingrese su usuario de Mercado Libre"
        redirect_back_or_default(spree.root_path)
        return
      end

      correct_string, content = parsear_combo_compuestos(order.ml_purchase_id)

      if (correct_string)
        order.save
      else
        flash[:error] = content
        redirect_back_or_default(spree.root_path)
        return
      end

      redirect_to ordenar_combo_compuesto_path params[:ml_purchase_id]

    end


    def register_ml_combo #Esto es para entrar directamente con un combo en el link y poner solo el usuario...
      order = current_order(create_order_if_necessary: true)
      order.empty! #Las vacío sin importar que tengan, porque al agregarse un combo de ML solo debe haber combos de ML
      
      order.ml_user = params[:ml_user]
      order.ml_purchase_id = params[:ml_purchase_id]

      if (params[:ml_user] == "")
        flash[:error] = "Por favor ingrese su usuario de Mercado Libre"
        redirect_back_or_default(spree.root_path)
        return
      end

      correct_string, content = parsear_combo_compuestos(order.ml_purchase_id)

      if (correct_string)
        order.save
      else
        flash[:error] = content
        redirect_back_or_default(spree.root_path)
        return
      end

      redirect_to ordenar_combo_compuesto_path params[:ml_purchase_id]
    end

    def remove_combo_aplicado
      order = current_order
      order.ml_user = nil
      order.ml_purchase_id = nil
      order.save
      combo_aplicado = order.combo_aplicados.find(params[:combo_aplicado])
      order.line_items.where(combo_aplicado: combo_aplicado).each do |line_item|
        order.contents.remove_line_item(line_item)
      end
      combo_aplicado.destroy
      redirect_back_or_default(spree.root_path)
    end

    def new_combo_order_params
      { currency: current_currency, store_id: current_store.id, user_id: try_spree_current_user.try(:id), combo_order: true }
    end

    def populate_combos
      # byebug
      if params[:combo_order] == "true"
        # Si es una orden de combo entonces creo una orden especial
        order = Spree::Order.create!(new_combo_order_params)
        
      else
        # Si no agrego el combo al carrito normal
        order = current_order(create_order_if_necessary: true)
      end

      validar_que_no_hay_combos_aplicados(order)
      set_bill_address_if_blank(order)

      ActiveRecord::Base.transaction do
        params[:combos].each do |hash, parameters|
          combo = Combo.find(parameters[:combo_id])
          agregar_items_de_combo(order, combo, parameters[:quantity].to_i, parameters)
        end
        order.validate_combos

        validate_population(order)
      end
    end

    def validate_population(order)
      # byebug
      if order.errors.empty?
        flash[:success] = "Combo agregado al carrito!"
        if order.es_de_mercadolibre? # Caso ML directo al checkout!
          redirect_to checkout_state_path(order.checkout_steps.first)
        elsif order.combo_order? 
          redirect_to combo_order_checkout_address_path(order.id)

          # redirect_to checkout_state_path(:address)
        else
          redirect_to spree.root_path
        end
      else
        errores = ""
        order.errors.messages[:"Combo_Errors"].each do |m|
          errores += "#{m.html_safe}<br>"
        end
        go_back(errores)
      end
    end

    def agregar_items_de_combo(order, combo, quantity, parameters)
      combo_aplicado = order.combo_aplicados.create(combo: combo, quantity: quantity)

      parameters.each do |key,value|
        quantity = value.to_i
        if (key.starts_with? "quantity_") && quantity.between?(1, 2_147_483_647)
          variant_id = key.split("_")[1]
          variant  = Spree::Variant.find(variant_id)
          options  = params[:options] || {}
          begin
            line_item = order.contents.add(variant, quantity, options, combo_aplicado)
          rescue ActiveRecord::RecordInvalid => e
            error = e.record.errors.full_messages.join(", ")
            go_back(error)
          end
        end
      end
    end

    def set_bill_address_if_blank(order)
      if order.bill_address.blank? && order.user.present? # Sin esto pincha cuando un guest ordena un combo
        order.bill_address = order.user.bill_address
      end
    end

    def validar_que_no_hay_combos_aplicados(order)
      #Valido que no exista previamente un combo ML
      if order.present?
        if order.combo_aplicados.present?
          if order.combo_aplicados.first.present?
            go_back("No puede agregar combos a un pedido de Mercado Libre")
          end
        end
      end
    end
  end
end

