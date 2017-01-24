class AddHelpContentToStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :help_content, :text
  end
end
