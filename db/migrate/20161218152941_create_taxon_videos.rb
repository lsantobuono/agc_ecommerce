class CreateTaxonVideos < ActiveRecord::Migration
  def change
    create_table :spree_taxons_videos do |t|
      t.string :video
      t.string :descripcion
      t.timestamps
      t.integer :taxon_id, :null => false, :references => [:spree_taxons, :id]
    end
  end
end
