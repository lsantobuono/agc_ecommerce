module Spree
  OrderUpdater.class_eval do

    def update_item_total
      order.item_total = line_items.sum('(price - (bonification * price / 100.00))* quantity ')
      update_order_total
    end
  
  end
end
