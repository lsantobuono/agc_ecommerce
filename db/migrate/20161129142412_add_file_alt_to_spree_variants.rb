class AddFileAltToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :file_alt, :string
  end
end
