class CreateDownloadableFile < ActiveRecord::Migration
  def change
    create_table :downloadable_files do |t|
      t.string :file
      t.string :name
      t.boolean :private

      t.timestamps null: false
    end
  end
end
