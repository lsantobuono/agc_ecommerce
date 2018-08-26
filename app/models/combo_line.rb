# == Schema Information
#
# Table name: combo_lines
#
#  id         :integer          not null, primary key
#  combo_id   :integer          not null
#  product_id :integer
#  quantity   :integer          not null
#  price      :decimal(, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  taxon_id   :integer
#

class ComboLine < ActiveRecord::Base
  belongs_to :combo
  belongs_to :taxon, class_name: 'Spree::Taxon'
  belongs_to :product, class_name: 'Spree::Product'

  scope :with_product, -> { where('product_id IS NOT NULL') }
  scope :with_taxon, -> { where('taxon_id IS NOT NULL') }

  validates :quantity, presence: true
end
