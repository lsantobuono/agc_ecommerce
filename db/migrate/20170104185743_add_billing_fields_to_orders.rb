class AddBillingFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :tipo_factura, :integer
    add_column :spree_orders, :metodo_envio, :integer
    add_column :spree_orders, :metodo_envio_otros, :string
    add_column :spree_orders, :checkout_notes, :string
    add_column :spree_addresses, :dni_cuit, :string
  end
end
