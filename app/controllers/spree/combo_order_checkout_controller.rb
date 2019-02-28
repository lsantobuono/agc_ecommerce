module Spree
  class ComboOrderCheckoutController < Spree::StoreController
    def address
      @order = Spree::Order.find(params[:order_id])
      @state = "address"
      render 'edit'
    end

    def address_update
      @order = Spree::Order.find(params[:order_id])
      # byebug
      
      @order.update_attributes(order_params)
      redirect_to combo_order_checkout_metodo_envio_path(@order.id)
    end

    def metodo_envio
      @order = Spree::Order.find(params[:order_id])

      @state = "metodo_envio"
      render 'edit'
    end

    def metodo_envio_update
      @order = Spree::Order.find(params[:order_id])
      @order.update_attributes(order_params)
      redirect_to combo_order_checkout_forma_de_pago_path(@order.id)
    end
    def forma_de_pago
      @order = Spree::Order.find(params[:order_id])
      @state = "forma_de_pago"
      render 'edit'
    end

    def forma_de_pago_update
      @order = Spree::Order.find(params[:order_id])
    end

    def generar_mercadopago_preference
      @order = Spree::Order.find(params[:order_id])
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
        redirect_to preference["response"]["sandbox_init_point"]
      else
        redirect_to :back, alert: "Hubo un error al generar el link de pago"
      end
      # redirect_to :back, alert: "Hubo un error al generar el link de pago"
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
