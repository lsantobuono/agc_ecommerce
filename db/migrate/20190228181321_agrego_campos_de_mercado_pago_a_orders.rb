class AgregoCamposDeMercadoPagoAOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :mercadopago_preference_id, :string
    add_column :spree_orders, :mercadopago_init_point, :string
    add_column :spree_orders, :mercadopago_sandbox_init_point, :string
  end
end
