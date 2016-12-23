class CreateComboAplicados < ActiveRecord::Migration
  def change
    create_table :combo_aplicados do |t|
      t.references :combo, index: true, foreign_key: true, null: false
      t.references :spree_order, index: true, foreign_key: true, null: false
    end

    remove_column :spree_orders, :combo_id, :integer
    add_reference :spree_line_items, :combo_aplicado, foreign_key: true, index: true
  end
end
