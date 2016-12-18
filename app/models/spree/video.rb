module Spree
  class Video < ActiveRecord::Base
    self.table_name = "spree_taxons_videos"
    belongs_to :taxon
  end
end