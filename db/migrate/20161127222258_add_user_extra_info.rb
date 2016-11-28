class AddUserExtraInfo < ActiveRecord::Migration
  def change
    add_column :spree_users, :phone_number, :string
    add_column :spree_users, :first_name, :string
    add_column :spree_users, :last_name, :string
    add_column :spree_users, :enterprise, :string
    add_column :spree_users, :address, :string
  end
end
