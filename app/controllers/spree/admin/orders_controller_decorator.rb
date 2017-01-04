module Spree::Admin
  OrdersController.class_eval do
    def new
      @order = Spree::Order.create(order_params.merge(creado_por_admin: true))
      redirect_to cart_admin_order_url(@order)
    end
    
    def approve
      @order.create_proposed_shipments
      @order.finalize!
      @order.approved_by(try_spree_current_user)
      flash[:success] = Spree.t(:order_approved)
      redirect_to :back
    end

    def resend
      if (@order.email == nil)
        flash[:error] = Spree.t(:error_email_resent)
      else
        Spree::OrderMailer.confirm_email(@order.id, true).deliver_later
        flash[:success] = Spree.t(:order_email_resent)
      end
      redirect_to :back
    end

  end
end
