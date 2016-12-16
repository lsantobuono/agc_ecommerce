class ComboLine < ActiveRecord::Base
  belongs_to :combo
  belongs_to :taxon, class_name: 'Spree::Taxon'

  validates :taxon, :quantity, presence: true
end
