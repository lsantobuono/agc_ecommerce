class CreateAppliedComplements < ActiveRecord::Migration
  def change
    create_table :applied_complements do |t|
      t.references :complement, index: true, foreign_key: true, null: false
      t.references :taxon, index: true, null: false
      t.integer :quantity, null: false

      t.timestamps null: false
    end
    add_foreign_key :applied_complements, :spree_taxons, column: :taxon_id
  end
end
