class Combo < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :category
  has_many :combo_lines
  has_many :combo_lines_products, -> { with_product }, class_name: 'ComboLine'
  has_many :combo_lines_taxons, -> { with_taxon }, class_name: 'ComboLine'

  accepts_nested_attributes_for :combo_lines_products, allow_destroy: true
  accepts_nested_attributes_for :combo_lines_taxons, allow_destroy: true

  mount_uploader :image, Spree::ComboImageUploader

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
end
