module Spree
  class Video < ActiveRecord::Base
    self.table_name = "spree_taxons_videos"

    validates :video, presence: true

    belongs_to :taxon
  end
end