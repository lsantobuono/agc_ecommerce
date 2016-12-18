class Combo < ActiveRecord::Base
  acts_as_paranoid

  has_many :combo_lines
  accepts_nested_attributes_for :combo_lines, allow_destroy: true

  mount_uploader :image, Spree::ComboImageUploader

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true

  def validateGeneratedOrder(order)
    orderProductQuantities = {}
    orderTaxonQuantities = {}


  	order.line_items.each do |li|
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
  	#if (orderQuantities.count < self.combo_lines.count) # menor porque como los prod pueden tener mas de un taxon, puede generar que tenga mas 
  	#	return false                                       # orderquantitis que combo lines
  	#end

    #Lo que tengo en orderQuantitis es un array con key : product_id, y value: cantidad
    #Entonces, para validar el combo line de tipo producto es trivial, en taxon tengo que ver que el producto sea hijo de esa taxon
    #Podria haber quilombos si un combo tiene un taxon, y tambien un hijo de esa taxon, hay que consultar esto....    
    self.combo_lines.each do |cl|
      matcheo=false
      if cl.taxon_id != nil # Validacion para COMBO LINE de tipo TAXOn, una vez definida la base revisar.
        orderTaxonQuantities.each do |key, value|
          if (cl.taxon_id == key && cl.quantity == value)
            matcheo=true
          end
        end
      elsif cl.product_id != nil
        orderProductQuantities.each do |key,value|
          if (cl.product_id==key && cl.quantity == value)
            matcheo=true
          end
        end
      end
      if (!matcheo)
        return false
      end
    end

    return true
  end
end

#	orderQuantities.each do |key,value|
#		matcheo = false#
#		self.combo_lines.each do |cl|
 #     if cl.taxon_id != nil # Validacion para COMBO LINE de tipo TAXOn, una vez definida la base revisar.
 #       if (categories.include? key && cl.quantity == value)
 #         matcheo = true
 #       end
 #     elsif cl.product_id != nil  # Validacion para COMBO LINE de tipo PRODUCTO, una vez definida la base revisar.
 #       if (cl.product_id == key && cl.quantity == value ) # Si tengo la cantidad exactas de ese producto
 #         matcheo = true
 #       end
 #     end
#		end#
#		if (!matcheo)#
#			return false
#		end
#	end

#	return true
 # end

