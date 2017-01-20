class AddModerationStatusToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :moderation_status, :integer, null: false, default: 0
  end
end
