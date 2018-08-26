# == Schema Information
#
# Table name: spree_taxons_videos
#
#  id          :integer          not null, primary key
#  video       :string
#  descripcion :string
#  created_at  :datetime
#  updated_at  :datetime
#  taxon_id    :integer          not null
#

module Spree
  class Video < ActiveRecord::Base
    self.table_name = "spree_taxons_videos"

    validates :video, presence: true

    belongs_to :taxon
  end
end
