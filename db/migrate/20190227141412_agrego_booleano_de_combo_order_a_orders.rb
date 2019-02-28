class AgregoBooleanoDeComboOrderAOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :combo_order, :boolean, null: false, default: false
  end
end
