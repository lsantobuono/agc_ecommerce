class CreateCombos < ActiveRecord::Migration
  def change
    create_table :combos do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps null: false
    end

    create_table :combo_lines do |t|
      t.integer :combo_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false
      t.decimal :price
      t.timestamps null: false
    end

    change_table :spree_orders do |t|
      t.integer :combo_id
    end
  end
end
