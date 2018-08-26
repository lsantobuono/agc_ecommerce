# == Schema Information
#
# Table name: combo_aplicados
#
#  id             :integer          not null, primary key
#  combo_id       :integer          not null
#  spree_order_id :integer          not null
#  quantity       :integer          default(1), not null
#

class ComboAplicado < ActiveRecord::Base
  belongs_to :combo
  belongs_to :order, class_name: 'Spree::Order', foreign_key: 'spree_order_id', inverse_of: :combo_aplicados

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
