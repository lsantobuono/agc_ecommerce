class AddForeingKeysToCombos < ActiveRecord::Migration
  def change
    add_foreign_key :combo_lines, :combos
    # add_foreign_key :combo_lines, :spree_products
  end
end
