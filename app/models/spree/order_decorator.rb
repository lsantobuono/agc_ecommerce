module Spree
  Order.class_eval do
    unless respond_to? :tipo_facturas # Esto es para fixear un bug raro, por algun motivo carga dos veces este decorator
      enum tipo_factura: [:consumidor_final, :factura_b, :factura_a]
      enum metodo_envio: [:mercado_envios, :retiro_local, :micro, :other]
      enum moderation_status: [:pending, :notified, :approved]
    end

    has_many :combo_aplicados, inverse_of: :order, foreign_key: :spree_order_id, dependent: :destroy

    checkout_flow do
      go_to_state :address, if: ->(order) { order.requiere_address? }
      go_to_state :metodo_envio, if: ->(order) { !order.creado_por_admin? }
      go_to_state :confirmar, if: ->(order) { !order.creado_por_admin? }
      # 
      # go_to_state :delivery
      # go_to_state :payment, if: ->(order) { order.payment_required? }
      # go_to_state :confirm
      # go_to_state :confirm, if: ->(order) { order.confirmation_required? }
      go_to_state :complete
      # remove_transition from: :delivery, to: :confirm
    end

    def can_approve?
      moderation_status == 'notified' || (moderation_status == 'pending' && email.blank?)
    end

    def deliver_order_confirmation_email
      OrderMailer.custom_confirm_email(id).deliver_later 
      update_column(:confirmation_delivered, true)
    end

    def requiere_address?
      return true unless es_de_mercadolibre?
      combo = combo_aplicados.first.try(:combo)
      return true unless combo.present?

      if (!combo.caro?) # Si no es caro no va a pedir address.. 
        #entonces le pongo tipo consumidor final.. solo los ML Combo deberian llegar aca, el resto ya retorno address
        self.tipo_factura="consumidor_final"
      end

      combo.caro?
    end

    def es_de_mercadolibre?
      ml_user.present?
    end

    def require_email
      return false if es_de_mercadolibre?
      true unless new_record? or ['cart', 'address'].include?(state)
    end

    def metodo_envios
      if es_de_mercadolibre?
        ['mercado_envios', 'retiro_local', 'micro', 'other']
      else
        ['retiro_local', 'micro', 'other']
      end
    end

    before_validation(on: :create) do
      self.number = Spree::Core::NumberGenerator.new(prefix: 'P').send(:generate_permalink, Spree::Order)
    end

    after_save() do
      if (self.state == "complete")
        self.invoice_for_order
      end
    end

    Spree::Order.state_machine.before_transition from: :address, do: :validate_tipo_factura
    Spree::Order.state_machine.before_transition to: :metodo_envio, do: :assign_default_addresses!
    Spree::Order.state_machine.before_transition from: :metodo_envio, do: :validate_metodo_envio
    Spree::Order.state_machine.before_transition from: :metodo_envio, do: :persist_user_address!
    Spree::Order.state_machine.before_transition to: :complete, do: :validate_combos
    # Al crear los shipments se decrementa el stock
    # Spree::Order.state_machine.before_transition :to => :complete, :do => :create_proposed_shipments


    # Este decorator es de la gema de print invoice... por algun motivo si no lo agrego aca no anda, creo que tiene que ver
    # con todo el quilombo de redefinicion de estados que hacemos en este decorator, jode al otro decorator (el de la gema)
    Spree::Order.state_machine.before_transition to: :complete, do: :invoice_for_order


    def invoice_for_order
     doc = nil
     if (self.tipo_factura == "consumidor_final" )
        doc=bookkeeping_documents.create(template: 'invoice_cf')
      elsif (self.tipo_factura == "factura_a")
        doc=bookkeeping_documents.create(template: 'invoice_a')
      elsif (self.tipo_factura == "factura_b")
        doc=bookkeeping_documents.create(template: 'invoice_b')
      else 
        doc=bookkeeping_documents.create(template: 'invoice_mostrador') # Si no tiene tipo es xq la crearon a mano y se usa el pdf mostrador
      end
      if (doc != nil)
        doc.pdf # Sin esta llamada el archivo PDF no se genera y no se puede enviar adjunto porque no existe el file.. si el admin accede al file
        # se genera, pero van a querer enviarlo sin tener que acceder cada vez.
        # El problema es que esto se procesa como 4 veces cuando se realiza un checkout (imagin que porque la orden se guarda muchas veces en ese proceso)
        # y genera basura en disco... pero en un principio no seria drama, se puede hacer un cleaner de archivos viejos y ya.
      end
    end

    def approve!
      update_attributes(considered_risky: false, moderation_status: :approved)
    end

    def assign_default_addresses!
      if user
        clone_billing
        clone_shipping
      end
    end

    def clone_billing_address
      if bill_address
        if self.ship_address.nil?
          self.ship_address = bill_address.clone
        else
          self.ship_address.attributes = bill_address.attributes.except('id', 'updated_at', 'created_at')
        end
      end
      true
    end

    def shipping_eq_billing_address?
      return true unless bill_address.present?
      (bill_address.empty? && ship_address.empty?) || bill_address.same_as?(ship_address)
    end

    def update_line_item_prices!
      # Esta funcion le ponia el impuesto de VAT por zona, y por algun motivo rompia el tema de las variaciones de precio por cantidad
      # Como no creo que nos afecte lo del VAT, directamente la vacío aca para no entrar en detalles y hacer lio
    end

    def validate_metodo_envio
      unless creado_por_admin? || metodo_envio.present?
        self.errors.add(:base, 'Seleccione el método de envío')
        return false
      end
    end

    def validate_tipo_factura
      unless creado_por_admin? || tipo_factura.present?
        self.errors.add(:base, 'Seleccione el tipo de factura')
        return false
      end
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
