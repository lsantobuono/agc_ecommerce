class ComboLine < ActiveRecord::Base
  belongs_to :combo
  belongs_to :taxon, class_name: 'Spree::Taxon'
  belongs_to :product, class_name: 'Spree::Product'

  scope :with_product, -> { where('product_id IS NOT NULL') }
  scope :with_taxon, -> { where('taxon_id IS NOT NULL') }
end
