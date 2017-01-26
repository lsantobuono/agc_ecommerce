module Spree
  module Stock
    Quantifier.class_eval do
      def can_supply?(required = 1)
        security_stock = variant.security_stock || variant.product.security_stock || 0
        # Si la variant tiene security stock, lo uso, si no uso el del producto, si ninguno lo tiene setaeado funciono normalmente con el 
        # valor pasado o el 1 default.
        variant.available? && ((total_on_hand - security_stock) >= required || backorderable?)
      end
    end
  end
end

