class AddDeletedAtToCombos < ActiveRecord::Migration
  def change
    add_column :combos, :deleted_at, :datetime
  end
end
