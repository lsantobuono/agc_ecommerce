class AgregoQuantityAComboAplicados < ActiveRecord::Migration
  def change
    add_column :combo_aplicados, :quantity, :integer, null: false, default: 1
  end
end
