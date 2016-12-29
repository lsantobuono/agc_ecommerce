class AddCreadoPorAdminToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :creado_por_admin, :boolean, default: false, null: false
  end
end
