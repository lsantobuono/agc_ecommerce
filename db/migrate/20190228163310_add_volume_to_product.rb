class AddVolumeToProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :volume, :float
    add_column :spree_products, :restrictive_measure, :float
  end
end
