class AddDescriptionAndImageToCombo < ActiveRecord::Migration
  def change
    add_column :combos, :description, :string
    add_column :combos, :image, :string
  end
end
