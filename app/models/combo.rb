# == Schema Information
#
# Table name: combos
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  code               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#  description        :string
#  image              :string
#  hidden             :boolean
#  caro               :boolean
#  category_id        :integer
#  price_cash         :decimal(, )
#  price_mercado_pago :decimal(, )
#

class Combo < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :category
  has_many :combo_lines
  has_many :combo_lines_products, -> { with_product }, class_name: 'ComboLine'
  has_many :combo_lines_taxons, -> { with_taxon }, class_name: 'ComboLine'
  
  has_many :images, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: 'Spree::Image'

  accepts_nested_attributes_for :combo_lines_products, allow_destroy: true
  accepts_nested_attributes_for :combo_lines_taxons, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true

  mount_uploader :image, Spree::ComboImageUploader

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true

  ransacker :name_unaccented, type: :string do |parent|
    Arel.sql("unaccent(\"name\")")
  end
end
