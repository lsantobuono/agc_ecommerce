class AddAvatarToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :file, :string
  end
end
