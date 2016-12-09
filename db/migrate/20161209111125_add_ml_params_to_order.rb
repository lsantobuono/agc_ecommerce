class AddMlParamsToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :ml_user, :string
    add_column :spree_orders, :ml_purchase_id, :string    
  end
end
