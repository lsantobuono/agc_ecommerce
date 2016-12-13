module Spree::Admin
  OrdersController.class_eval do 
    def approve
      @order.create_proposed_shipments
      @order.finalize!
      @order.approved_by(try_spree_current_user)
      flash[:success] = Spree.t(:order_approved)
      redirect_to :back
    end
  end
end
