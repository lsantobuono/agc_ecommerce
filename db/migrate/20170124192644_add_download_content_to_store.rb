class AddDownloadContentToStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :download_content, :text
  end
end
