class AddSecurityStockToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :security_stock, :int  	
  end
end
