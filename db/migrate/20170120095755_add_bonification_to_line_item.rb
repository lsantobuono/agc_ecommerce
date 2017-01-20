class AddBonificationToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :bonification, :integer, :null => false, :default => 0
  end
end
