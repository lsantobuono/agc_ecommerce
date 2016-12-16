module Spree
  OrdersController.class_eval do 



    # El unico motivo por el que pongo esto es para no redirigir al carrito, no deberia tocarse nada mas !!!
    def populate
      order    = current_order(create_order_if_necessary: true)
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
       # respond_with(order) do |format|
          #format.html { redirect_to cart_path }
       # end
      end
    end


    def populate_combos
      
      combo = Combo.find(params[:combo_id])
      current_order(create_order_if_necessary: true).empty! # Le vacío la orden actual... Quiza con un Order.new sea suficiente, pero me da un
      #poco de miedo meterme  aver todo el codigo de la current order, y ver si tiene alguna logica compleja acoplada.

      order = current_order(create_order_if_necessary: true)
  
      if order.user != nil # Sin esto pincha cuando un guest ordena un combo
        order.bill_address = order.user.bill_address
      end
    
      error = false

      order.ml_user ||=params[:ml_user] 
      order.ml_purchase_id ||=params[:ml_purchase_id] 
      order.combo_id ||= params[:combo_id]
      
      params.each do |key,value|
        if key.starts_with? "quantity_"
          variant_id = key.split("_")[1]
          variant  = Spree::Variant.find(variant_id)
          quantity = value.to_i
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
        end
      end

      if combo.validateGeneratedOrder order
        order.save!
        redirect_to checkout_state_path(order.checkout_steps.first)
        return
      else
        error= "Hubo un error en la validación de su orden, por favor intentelo nuevamente o pongase en contacto con nosotros"
        order.delete
        if error
          flash[:error] = error
          redirect_back_or_default(spree.root_path)
        end
      end
    end

    def empty
      if @order = current_order
        @order.empty!
        @order.combo_id=nil
        @order.ml_user=nil
        @order.ml_purchase_id=nil
        @order.save!
      end

      redirect_to spree.cart_path
    end

  end
end

