class AddPosToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :pos, :integer
  end
end
