module Spree
  OrderUpdater.class_eval do

    def update_item_total
      if order.combo_order?
        order.item_total = order.total_combo_order
      else
        order.item_total = line_items.sum('(price - (bonification * price / 100.00))* quantity ')
      end
      update_order_total
    end
  
  end
end
