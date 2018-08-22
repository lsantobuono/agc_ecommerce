class DownloadableFile < ActiveRecord::Base
  mount_uploader :file, Spree::FilesUploader
  
  ransacker :name_unaccented, type: :string do |parent|
     Arel.sql("unaccent(\"name\")")
  end

end