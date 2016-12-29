class AddCustomMailHeaderToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :custom_mail_header, :string
  end
end
