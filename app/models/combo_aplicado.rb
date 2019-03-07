# == Schema Information
#
# Table name: combo_aplicados
#
#  id                 :integer          not null, primary key
#  combo_id           :integer          not null
#  spree_order_id     :integer          not null
#  quantity           :integer          default(1), not null
#  price_cash         :decimal(, )
#  price_mercado_pago :decimal(, )
#

class ComboAplicado < ActiveRecord::Base
  belongs_to :combo
  belongs_to :order, class_name: 'Spree::Order', foreign_key: 'spree_order_id', inverse_of: :combo_aplicados

  VOLUME_BOXES = [1728,3375,4000,6000,8000,12000,16000,39000,55000]
  RESTRICTIVE_MEASURE_BOXES = [12,15,20,20,20,30,40,45,45]

  def dimensions_and_weight
    "#{dimensions},#{get_weight.to_i}"
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
    }[get_minimum_box]
  end

  #Esto probablemente termine en orden, por si hay más de un combo aplicado
  def get_minimum_box
    volume = get_volume
    restrictive_measure = get_restrictive_measure

    #Básicamente busco en orden el mínimo volumen que entre, y aparte que la medida restrictiva se de 
    ComboAplicado::VOLUME_BOXES.each_with_index do |vol,index|
      if volume <= vol && restrictive_measure <= ComboAplicado::RESTRICTIVE_MEASURE_BOXES[index]
        return vol
      end
    end
  end

  def get_volume
    volume = 0
    order.line_items.where(combo_aplicado: self).each do  |li|
      if li.variant.product.volume.present? && li.quantity.present?
        volume += li.variant.product.volume * li.quantity
      end
    end
    return volume
  end

  def get_weight
    weight = 0
    order.line_items.where(combo_aplicado: self).each do  |li|
      if li.variant.product.weight.present? && li.quantity.present?
        weight += li.variant.product.weight * li.quantity
      end
    end
    return weight
  end

  def get_restrictive_measure
    current_max = -1
    order.line_items.where(combo_aplicado: self).each do  |li|
      if li.variant.product.restrictive_measure.present? && current_max < li.variant.product.restrictive_measure
        current_max = li.variant.product.restrictive_measure
      end
    end
    return current_max
  end

  def validate!
    orderProductQuantities = {}
    orderTaxonQuantities = {}

    order.line_items.where(combo_aplicado: self).each do |li|
      var = Spree::Variant.find(li.variant_id)

      # Lleno la lista de productos - quantity
      if (orderProductQuantities[var.product.id] == nil)
         orderProductQuantities[var.product.id] = 0
      end
      orderProductQuantities[var.product.id] += li.quantity

      # Lleno la lista de taxons - quantity
      var.product.all_parents.each do |t|
        if (orderTaxonQuantities[t.id] == nil)
          orderTaxonQuantities[t.id] = 0
        end
        orderTaxonQuantities[t.id] += li.quantity
      end
    end

    #Lo que tengo en orderQuantitis es un array con key : product_id, y value: cantidad
    #Entonces, para validar el combo line de tipo producto es trivial, en taxon tengo que ver que el producto sea hijo de esa taxon
    #Podria haber quilombos si un combo tiene un taxon, y tambien un hijo de esa taxon, hay que consultar esto....

    combo.combo_lines_taxons.each do |cl|
      cantidad_requerida = cl.quantity * self.quantity
      matcheoTaxons=false
      orderTaxonQuantities.each do |key, value|
        if (cl.taxon_id == key && cantidad_requerida == value)
          matcheoTaxons=true
        end
      end
      if !matcheoTaxons
        order.errors.add("Combo_Errors", "Error en la sumatoria de productos de la categoría <b> #{cl.taxon.name} </b>. La suma debe ser de <b> #{cantidad_requerida} </b>")
      end
    end

    combo.combo_lines_products.each do |cl|
      cantidad_requerida = cl.quantity * self.quantity
      matcheoProductos=false
      orderProductQuantities.each do |key,value|
        if (cl.product_id==key && cantidad_requerida == value)
           matcheoProductos=true
        end
      end
      if !matcheoProductos
        order.errors.add("Combo_Errors", "Error en la sumatoria de productos del producto <b> #{cl.product.name} </b>. La suma debe ser de <b> #{cantidad_requerida} </b>")
      end
    end
  end
end
