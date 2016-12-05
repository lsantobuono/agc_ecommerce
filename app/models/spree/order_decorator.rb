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

  end
end
