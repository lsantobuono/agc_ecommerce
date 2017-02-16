class ChangeBonificationToDecimal < ActiveRecord::Migration
  def change
    change_column :spree_line_items, :bonification, :decimal, precision: 10, scale: 2, default: 10.0, null: false
  end
end
