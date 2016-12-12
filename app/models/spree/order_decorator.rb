module Spree
  Order.class_eval do
    belongs_to :combo

    checkout_flow do
      go_to_state :address
      go_to_state :confirmar
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

    Spree::Order.state_machine.before_transition :to => :complete, :do => :validate_combo

    # Al crear los shipments se decrementa el stock
    Spree::Order.state_machine.before_transition :to => :complete, :do => :create_proposed_shipments

    def update_line_item_prices!
      # Esta funcion le ponia el impuesto de VAT por zona, y por algun motivo rompia el tema de las variaciones de precio por cantidad
      # Como no creo que nos afecte lo del VAT, directamente la vacío aca para no entrar en detalles y hacer lio
    end

    def validate_combo
      
      if (self.combo_id != nil)
        combo = Combo.find(self.combo_id)
        if !combo.validateGeneratedOrder self
          restart_checkout_flow
          errors.add(:base, Spree.t(:error_combo_validation))
          return false
        end
      end
      return true 
    end

  end
end
