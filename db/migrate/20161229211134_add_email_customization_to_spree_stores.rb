class AddEmailCustomizationToSpreeStores < ActiveRecord::Migration
  def change
    add_column :spree_stores, :confirm_email_header, :string
    add_column :spree_stores, :confirm_email_footer, :string
  end
end
