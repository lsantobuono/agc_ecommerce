module Spree
  class ComboOrderCheckoutController < Spree::StoreController
    def address
      @order = Spree::Order.find(params[:order_id])
      # @state = "address"
      render 'edit'
    end

    def metodo_envio
      @order = Spree::Order.find(params[:order_id])
      render 'edit'
    end

    def update
      @order = Spree::Order.find(params[:order_id])
      @order.update_attributes(order_params)
      if @order.next
        redirect_to url_for(controller: 'combo_order_checkout', action: @order.state)
      else
        render 'edit'
      end
    end

    def forma_de_pago
      @order = Spree::Order.find(params[:order_id])
      render 'edit'
    end
    def complete
      @order = Spree::Order.find(params[:order_id])
      render 'edit'
    end

    def select_forma_de_pago
      @order = Spree::Order.find(params[:order_id])
      @order.update_attributes(forma_de_pago: params[:forma_de_pago])
      # @order.next
        
      if @order.next
        if @order.state == "mercadopago"
          unless @order.mp_init_point.present?
            unless generar_mercadopago_preference
              return
            end
          end
          redirect_to @order.mp_init_point
        else
          redirect_to url_for(controller: 'combo_order_checkout', action: @order.state)
        end
      else
        render 'edit'
      end
    end

    def generar_mercadopago_preference
      $mp = MercadoPago.new(ENV['MERDACOPAGO_CLIENT_ID'], ENV['MERDACOPAGO_SECRET_KEY'])
      preference_data = {
          "items": [
              {
                  "title": "testCreate",
                  "quantity": 1,
                  "unit_price": 10.2,
                  "currency_id": "ARS"
              }
          ],
          "back_urls": {
              "success": payment_return_url(@order.id, status: "success"),
              "pending": payment_return_url(@order.id, status: "pending"),
              "failure": payment_return_url(@order.id, status: "failure"),
          },
          "external_reference": @order.id,
          "shipments": {
            "mode": "me2",
            "dimensions": "20x20x20,1000",

          }
      }
      preference = $mp.create_preference(preference_data)
      if preference["status"] == "201"
        @order.update_attributes(
          mercadopago_preference_id: preference["response"]["id"],
          mercadopago_init_point: preference["response"]["init_point"],
          mercadopago_sandbox_init_point: preference["response"]["sandbox_init_point"],
        )
        # redirect_to @order.mp_init_point
        true
      else
        redirect_to :back, alert: "Hubo un error al generar el link de pago"
        false
      end
    end

    def payment_return
    end

    private

      def order_params
        parameters = params.require(:order).permit(:tipo_factura, :metodo_envio, :checkout_notes,
          bill_address_attributes: [:firstname, :dni_cuit, :address1, :city, :country_id, :state_id, :phone, :id])
      end
  end
end
