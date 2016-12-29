module Spree
  module Admin
    module Orders
      CustomerDetailsController.class_eval do
        def order_params
          params.require(:order).permit(
            :email,
            :use_billing,
            :custom_mail_header,
            bill_address_attributes: permitted_address_attributes,
            ship_address_attributes: permitted_address_attributes
          )
        end
      end
    end
  end
end
