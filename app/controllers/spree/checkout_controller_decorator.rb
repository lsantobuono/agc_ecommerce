module Spree
  CheckoutController.class_eval do
    def before_metodo_envio
      # le mando las dos addresses
      # @order.bill_address ||= Address.build_default
      @order.ship_address ||= Address.build_default
    end

    def before_address
      # if the user has a default address, a callback takes care of setting
      # that; but if he doesn't, we need to build an empty one here
      @order.bill_address ||= Address.build_default if should_have_bill_address?
      @order.ship_address ||= Address.build_default if @order.checkout_steps.include?('delivery')
    end

    def should_have_bill_address?
      return true unless params[:order].present? && params[:order][:tipo_factura].present?
      @order.total > 1000 || params[:order][:tipo_factura] != "consumidor_final"
    end
  end
end
