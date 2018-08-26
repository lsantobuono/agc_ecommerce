# == Schema Information
#
# Table name: downloadable_files
#
#  id         :integer          not null, primary key
#  file       :string
#  name       :string
#  private    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DownloadableFile < ActiveRecord::Base
  mount_uploader :file, Spree::FilesUploader
  
  ransacker :name_unaccented, type: :string do |parent|
     Arel.sql("unaccent(\"name\")")
  end

end
