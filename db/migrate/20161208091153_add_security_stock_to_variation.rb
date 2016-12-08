class AddSecurityStockToVariation < ActiveRecord::Migration
  def change
    add_column :spree_variants, :security_stock, :int  	
  end
end
