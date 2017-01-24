module Spree
  CheckoutController.class_eval do
    def before_metodo_envio
      # le mando las dos addresses
      # @order.bill_address ||= Address.build_default
      @order.ship_address ||= Address.build_default unless params[:order].present? && params[:order][:metodo_envio].in?(['retiro_local', 'mercado_envios'])
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

    def check_registration
      return unless Spree::Auth::Config[:registration_step]
      return if spree_current_user or current_order.email or current_order.es_de_mercadolibre?
      store_location
      redirect_to spree.checkout_registration_path
    end
  end
end
