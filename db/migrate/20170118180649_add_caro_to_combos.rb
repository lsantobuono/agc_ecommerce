class AddCaroToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :caro, :boolean
  end
end
