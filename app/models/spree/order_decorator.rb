module Spree
  Order.class_eval do
    unless respond_to? :tipo_facturas # Esto es para fixear un bug raro, por algun motivo carga dos veces este decorator
      enum tipo_factura: [:consumidor_final, :factura_b, :factura_a]
      enum metodo_envio: [:mercado_envios, :retiro_local, :micro_domicilio, :micro_terminal, :motomensajeria, :other, :mercado_envios_mercadopago]
      enum moderation_status: [:pending, :notified, :approved, :delivered]
      enum forma_de_pago: [:en_local, :transferencia, :mercadopago]
      enum payment_status: [:pendiente, :aprobado, :rechazado]
    end

    has_many :combo_aplicados, inverse_of: :order, foreign_key: :spree_order_id, dependent: :destroy

    scope :incomplete, -> { where(completed_at: nil).where(combo_order: false) }

    checkout_flow do
      go_to_state :address
      go_to_state :metodo_envio, if: ->(order) { !order.creado_por_admin? }
      go_to_state :forma_de_pago, if: ->(order) { order.combo_order? && !order.creado_por_admin? }
      # go_to_state :mercadopago, if: ->(order) { order.combo_order? && order.forma_de_pago == "mercadopago" && !order.creado_por_admin? }
      # 
      # go_to_state :delivery
      # go_to_state :payment, if: ->(order) { order.payment_required? }
      # go_to_state :confirm
      # go_to_state :confirm, if: ->(order) { order.confirmation_required? }
      go_to_state :complete
      # remove_transition from: :delivery, to: :confirm
    end

    # Este metodo le pega a la API de mercado pago para traer las dimensiones que posta se enviaron, ya que 
    # si cambian los datos de pesos o medidas de los productos luego de creada la orden el otro metodo daria un valor erroneo
    def dimensions_and_weight_from_api
      if mercadopago_preference_id.present?
        $mp = MercadoPago.new(ENV['MERDACOPAGO_CLIENT_ID'], ENV['MERDACOPAGO_SECRET_KEY'])
        preference = $mp.get_preference(mercadopago_preference_id)
        preference["response"]["shipments"]["dimensions"]
      else
        "No se genero el pago"
      end
    rescue => e
      "No se pudo obtener las dimensiones de la API de MercadoPago. Error: #{e.message}"
    end


    VOLUME_BOXES = [1728,3375,4000,6000,8000,12000,16000,39000,55000,45000]
    RESTRICTIVE_MEASURE_BOXES = [12,15,20,20,20,30,40,45,45,90]


    def calculate_dimensions_and_weight
      "#{dimensions},#{get_weight.to_i}"
    end

    def dimensions_and_weight
      if metodo_envio == "mercado_envios_mercadopago"
        dimensions_and_weight_from_api
      else
        calculate_dimensions_and_weight
      end
    end

    def dimensions
      {
         1728 => '12x12x12',
         3375 => '15x15x15',
         4000 => '20x20x10',
         6000 => '20x20x15',
         8000 => '20x20x20',
        12000 => '30x20x20',
        16000 => '40x20x20',
        39000 => '45x35x25',
        55000 => '45x35x35',
        45000 => '90x25x20',
      }[get_minimum_box]
    end

    #Esto probablemente termine en orden, por si hay más de un combo aplicado
    def get_minimum_box
      volume = get_volume
      restrictive_measure = get_restrictive_measure

      #Básicamente busco en orden el mínimo volumen que entre, y aparte que la medida restrictiva se de 
      VOLUME_BOXES.each_with_index do |vol,index|
        if volume <= vol && restrictive_measure <= RESTRICTIVE_MEASURE_BOXES[index]
          return vol
        end
      end
    end

    def get_volume
      volume = 0
      self.line_items.each do  |li|
        if li.variant.product.volume.present? && li.quantity.present?
          volume += li.variant.product.volume * li.quantity
        end
      end
      return volume
    end

    def get_weight
      weight = 0
      self.line_items.each do  |li|
        if li.variant.product.weight.present? && li.quantity.present?
          weight += li.variant.product.weight * li.quantity
        end
      end
      return weight
    end

    def get_restrictive_measure
      current_max = -1
      self.line_items.each do  |li|
        if li.variant.product.restrictive_measure.present? && current_max < li.variant.product.restrictive_measure
          current_max = li.variant.product.restrictive_measure
        end
      end
      return current_max
    end

    def total_combo_order
      if forma_de_pago == 'mercadopago'
        price_mercado_pago
      else
        price_cash
      end
    end

    def price_cash
      return unless combo_order?
      combo_aplicado = combo_aplicados.first
      return 0 unless combo_aplicado.price_cash.present?
      (combo_aplicado.price_cash * combo_aplicado.quantity).round(2)
    end

    def price_mercado_pago
      return unless combo_order?
      combo_aplicado = combo_aplicados.first
      return 0 unless combo_aplicado.price_mercado_pago.present?
      (combo_aplicado.price_mercado_pago * combo_aplicado.quantity).round(2)
    end

    def can_approve?
      moderation_status == 'notified' || (moderation_status == 'pending' && email.blank?)
    end

    def deliver_order_confirmation_email
      OrderMailer.custom_confirm_email(id).deliver_later 
      update_column(:confirmation_delivered, true)
    end

    def mp_init_point
      if Rails.env.development?
        mercadopago_sandbox_init_point
      else
        mercadopago_init_point
      end
    end

    def should_hide_billing?
      !es_de_mercadolibre? && !combo_order? && total < 1000
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
        ['mercado_envios', 'retiro_local', 'micro_terminal', 'micro_domicilio', 'motomensajeria', 'other']
      elsif combo_order?
        ['mercado_envios_mercadopago', 'retiro_local', 'micro_terminal', 'micro_domicilio', 'motomensajeria', 'other']
      else
        ['retiro_local','micro_terminal', 'micro_domicilio', 'motomensajeria', 'other']
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
    Spree::Order.state_machine.before_transition from: :forma_de_pago, do: :validate_forma_de_pago
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

    def validate_forma_de_pago
      unless creado_por_admin? || forma_de_pago.present?
        self.errors.add(:base, 'Seleccione la forma de pago')
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

        self.ml_user = nil
        self.ml_purchase_id = nil
        self.save

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

    def complementos_para_mostrar
      cantidades_por_complemento.map do |id, count|
        # Un falso applied complement que es el resultado del group by
        applied_complement = AppliedComplement.new
        applied_complement.complement = Complement.find(id)
        applied_complement.quantity = count
        applied_complement
      end
    end

    def cantidades_por_complemento
      complementos = {}

      self.line_items.each do |line_item|
        line_item.variant.product.taxons.each do |taxons|
          taxons.self_and_ancestors.each do |taxon|
            taxon.applied_complements.each do |applied_complement|
              if complementos[applied_complement.complement_id].present?
                complementos[applied_complement.complement_id] += applied_complement.quantity * line_item.quantity
              else
                complementos[applied_complement.complement_id] = applied_complement.quantity * line_item.quantity
              end
            end
          end
        end
      end
      complementos
    end
  end
end
