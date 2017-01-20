module Spree
  module Admin
    module OrdersHelper
      def line_item_shipment_price(line_item, quantity, bonification)
        Spree::Money.new((line_item.price - (bonification * line_item.price / 100)) * quantity, { currency: line_item.currency })
      end
    end
  end
end
