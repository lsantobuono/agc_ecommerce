class AddFileNameToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :file_name, :string
  end
end
