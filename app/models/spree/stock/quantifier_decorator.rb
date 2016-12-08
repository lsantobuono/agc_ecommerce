module Spree
  module Stock
    Quantifier.class_eval do
      def can_supply?(required = 1)
      	auxRequired = variant.security_stock
      	if (auxRequired == nil)
      		auxRequired = variant.product.security_stock
      	end
      	
      	if (auxRequired == nil)
      		auxRequired = required
		end
      	# Si la variant tiene security stock, lo uso, si no uso el del producto, si ninguno lo tiene setaeado funciono normalmente con el 
      	# valor pasado o el 1 default.
        variant.available? && (total_on_hand >= auxRequired || backorderable?)
      end
    end
  end
end

