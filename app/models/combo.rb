class Combo < ActiveRecord::Base
  acts_as_paranoid

  has_many :combo_lines
  accepts_nested_attributes_for :combo_lines, allow_destroy: true

  mount_uploader :image, Spree::ComboImageUploader

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true

  def validateGeneratedOrder(order)
  	orderQuantities = {}


  	order.line_items.each do |li|
  		var = Spree::Variant.find(li.variant_id)
      var.product.taxons.each do |t|
    		if (orderQuantities[t.id] == nil)
    			orderQuantities[t.id] = 0
  	   	end
        orderQuantities[t.id] += li.quantity
      end
  	end

	if (orderQuantities.count < self.combo_lines.count) # menor porque como los prod pueden tener mas de un taxon, puede generar que tenga mas 
		return false                                       # orderquantitis que combo lines
	end

	orderQuantities.each do |key,value|
		matcheo = false
		self.combo_lines.each do |cl|
			if (cl.taxon.id == key && cl.quantity == value)
				matcheo = true
			end
		end
		if (!matcheo)
			return false
		end
	end

	return true
  end
end
