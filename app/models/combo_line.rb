class ComboLine < ActiveRecord::Base
  belongs_to :combo
  belongs_to :product, class_name: 'Spree::Product'

  validates :product, :quantity, presence: true
end
