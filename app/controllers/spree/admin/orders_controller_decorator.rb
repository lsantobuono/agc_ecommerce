module Spree::Admin
  OrdersController.class_eval do
    before_action :load_order, only: [:edit, :update, :destroy, :cancel, :resume, :approve, :notificate, :resend, :open_adjustments, :close_adjustments, :cart]

    def new
      @order = Spree::Order.create(order_params.merge(creado_por_admin: true))
      redirect_to cart_admin_order_url(@order)
    end

    def destroy
      begin
        if @order.destroy
          flash[:success] = Spree.t('notice_messages.order_deleted')
        else
          flash[:error] = Spree.t('notice_messages.order_not_deleted')
        end
      rescue ActiveRecord::RecordNotDestroyed => e
        flash[:error] = Spree.t('notice_messages.order_not_deleted')
      end

      respond_with(@order) do |format|
        format.html { redirect_to admin_orders_path }
        format.js  { render_js_for_destroy }
      end
    end

    def approve
      @order.create_proposed_shipments
      @order.finalize!
      @order.approved_by(try_spree_current_user)
      flash[:success] = Spree.t(:order_approved)
      redirect_to :back
    end

    def notificate
      @order.update_column(:moderation_status, 1)
      flash[:success] = Spree.t(:order_notificated)
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

    def initialize_order_events
      @order_events = %w{notificate approve cancel resume}
    end

  end
end
