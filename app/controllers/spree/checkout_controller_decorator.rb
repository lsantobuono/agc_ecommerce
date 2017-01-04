module Spree
  CheckoutController.class_eval do
    def before_metodo_envio
      # le mando las dos addresses
      # @order.bill_address ||= Address.build_default
      @order.ship_address ||= Address.build_default
    end
  end
end
