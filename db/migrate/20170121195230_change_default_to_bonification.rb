class ChangeDefaultToBonification < ActiveRecord::Migration
  def change
    change_column_default :spree_line_items, :bonification, 10
  end
end
