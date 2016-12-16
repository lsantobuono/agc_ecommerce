class AlterNameToProductIdComboLine < ActiveRecord::Migration
  def change
    add_column :combo_lines, :taxon_id, :int
  end
end
