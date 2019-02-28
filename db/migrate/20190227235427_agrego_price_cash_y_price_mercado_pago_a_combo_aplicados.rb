class AgregoPriceCashYPriceMercadoPagoAComboAplicados < ActiveRecord::Migration
  def change
    add_column :combo_aplicados, :price_cash, :decimal
    add_column :combo_aplicados, :price_mercado_pago, :decimal
  end
end
