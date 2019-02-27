module Spree
  class ComboOrderCheckoutController < Spree::StoreController
    def address
      @order = Spree::Order.find(params[:order_id])
      $mp = MercadoPago.new('2339547818559965', 'tkinvDd5RTZ1TqoXtamz6yW65MtHjfQC')
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
        puts preference
      end
    end

    def payment_return
    end
  end
end
