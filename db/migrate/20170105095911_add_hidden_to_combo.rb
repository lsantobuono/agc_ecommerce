class AddHiddenToCombo < ActiveRecord::Migration
  def change
    add_column :combos, :hidden, :boolean
  end
end
