class AgregoFormaDePagoAOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :forma_de_pago, :integer
  end
end
