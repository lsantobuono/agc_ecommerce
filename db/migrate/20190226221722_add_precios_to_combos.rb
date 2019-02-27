class AddPreciosToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :price_cash, :decimal
    add_column :combos, :price_mercado_pago, :decimal
  end
end
