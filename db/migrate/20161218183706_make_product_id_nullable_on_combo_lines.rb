class MakeProductIdNullableOnComboLines < ActiveRecord::Migration
  def change
    change_column_null :combo_lines, :product_id, true
  end
end
