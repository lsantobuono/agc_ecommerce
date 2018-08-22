class AddPrivateDownloadContentToStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :private_download_content, :text
  end
end
