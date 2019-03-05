class AgregoPaymentStatusAOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :payment_status, :integer
  end
end
