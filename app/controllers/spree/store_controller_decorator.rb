# module Spree
#   StoreController.class_eval do
#     def current_order(options = {})
#       options[:create_order_if_necessary] ||= false

#       if @current_order
#         @current_order.last_ip_address = ip_address
#         return @current_order
#       end

#       @current_order = find_order_by_token_or_user(options, true)

#       if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
#         @current_order = Spree::Order.create!(current_order_params)
#         @current_order.associate_user! try_spree_current_user if try_spree_current_user
#         @current_order.last_ip_address = ip_address
#       end

#       @current_order
#     end
#   end
# end
