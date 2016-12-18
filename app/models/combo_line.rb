class ComboLine < ActiveRecord::Base
  belongs_to :combo
  belongs_to :taxon, class_name: 'Spree::Taxon'
  belongs_to :product, class_name: 'Spree::Product'

end
