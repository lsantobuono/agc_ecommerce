class AddCategoryToCombos < ActiveRecord::Migration
  def change
    change_table :combos do |t|
      t.references :category, index: true
    end
    add_foreign_key :combos, :categories, column: :category_id
  end
end
