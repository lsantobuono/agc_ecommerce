class CreateComplements < ActiveRecord::Migration
  def change
    create_table :complements do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
