module Spree
  Order.class_eval do
    has_many :combo_aplicados, inverse_of: :order, foreign_key: :spree_order_id, dependent: :destroy

    checkout_flow do
      go_to_state :address
      go_to_state :confirmar, if: ->(order) { !order.creado_por_admin? }
      # 
      # go_to_state :delivery
      # go_to_state :payment, if: ->(order) { order.payment_required? }
      # go_to_state :confirm
      # go_to_state :confirm, if: ->(order) { order.confirmation_required? }
      go_to_state :complete
      # remove_transition from: :delivery, to: :confirm
    end

    def deliver_order_confirmation_email
      OrderMailer.custom_confirm_email(id).deliver_later 
      update_column(:confirmation_delivered, true)
    end

    Spree::Order.state_machine.before_transition :to => :complete, :do => :validate_combos

    # Al crear los shipments se decrementa el stock
    # Spree::Order.state_machine.before_transition :to => :complete, :do => :create_proposed_shipments

    def update_line_item_prices!
      # Esta funcion le ponia el impuesto de VAT por zona, y por algun motivo rompia el tema de las variaciones de precio por cantidad
      # Como no creo que nos afecte lo del VAT, directamente la vacío aca para no entrar en detalles y hacer lio
    end

    def validate_combos
      combo_aplicados.each do |combo_aplicado|
        combo_aplicado.validate!
      end
    end

    def empty!
      if completed?
        raise Spree.t(:cannot_empty_completed_order)
      else
        line_items.destroy_all
        updater.update_item_count
        adjustments.destroy_all
        shipments.destroy_all
        state_changes.destroy_all
        order_promotions.destroy_all
        combo_aplicados.destroy_all
        self.ml_user=nil
        self.ml_purchase_id=nil


        update_totals
        persist_totals
        restart_checkout_flow
        self
      end
    end

    def finalize!
      # lock all adjustments (coupon promotions, etc.)
      all_adjustments.each{|a| a.close}

      # update payment and shipment(s) states, and save
      updater.update_payment_state
      shipments.each do |shipment|
        shipment.update!(self)
        shipment.finalize!
      end

      updater.update_shipment_state
      save!
      updater.run_hooks

      touch :completed_at

      deliver_order_confirmation_email unless confirmation_delivered? || creado_por_admin?

      consider_risk
    end

  end
end
