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

#        redirect_to spree.root_path        
       # respond_with(order) do |format|
          #format.html { redirect_to cart_path }
       # end
      end
    end

    def register_ml
      order = current_order(create_order_if_necessary: true)

      order.ml_user =params[:ml_user]
      order.ml_purchase_id =params[:ml_purchase_id]

      if (params[:ml_user] == "")
        flash[:error] = "Por favor ingrese su usuario de Mercado Libre"
        redirect_back_or_default(spree.root_path)
        return
      end

      combo = Combo.where('lower(code) = ?', order.ml_purchase_id.downcase).first
      if (combo == nil)
        flash[:error] = "Se ingresó un id de combo inválido, por favor chequee que sea correcto, o comuniquese con nosotros"
        redirect_back_or_default(spree.root_path)
      else
        order.save
        redirect_to ordenar_combo_path combo
      end
    end

    def remove_combo_aplicado
      order = current_order
      combo_aplicado = order.combo_aplicados.find(params[:combo_aplicado])
      order.line_items.where(combo_aplicado: combo_aplicado).each do |line_item|
        order.contents.remove_line_item(line_item)
      end
      combo_aplicado.destroy
      redirect_back_or_default(spree.root_path)
    end

    def populate_combos
      combo = Combo.find(params[:combo_id])
      order = current_order(create_order_if_necessary: true)

      if order.bill_address.blank? && order.user.present? # Sin esto pincha cuando un guest ordena un combo
        order.bill_address = order.user.bill_address
      end
      ActiveRecord::Base.transaction do
        error = false

        combo_aplicado = ComboAplicado.create(combo: combo, order: order)

        params.each do |key,value|
          quantity = value.to_i
          if (key.starts_with? "quantity_") && quantity.between?(1, 2_147_483_647)
            variant_id = key.split("_")[1]
            variant  = Spree::Variant.find(variant_id)
            options  = params[:options] || {}
            begin
              line_item = order.contents.add(variant, quantity, options, combo_aplicado)
            rescue ActiveRecord::RecordInvalid => e
              error = e.record.errors.full_messages.join(", ")
            end
          end
        end

        if error
          flash[:error] = error
          redirect_back_or_default(spree.root_path)
          return
        end

        order.validate_combos

        if order.errors.empty?
          flash[:success] = "Combo agregado al carrito!"
          if order.es_de_mercadolibre? # Caso ML directo al checkout!
            redirect_to checkout_state_path(order.checkout_steps.first)
          else
            redirect_to spree.root_path
          end
        else
          flash[:error] = order.errors.messages[:"Combo_Errors"].first.html_safe
          redirect_back_or_default(spree.root_path)
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end

