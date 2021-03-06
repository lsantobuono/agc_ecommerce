# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#  pos        :integer
#

class Category < ActiveRecord::Base
  has_ancestry

  scope :leaves, lambda {
    joins("LEFT JOIN categories AS c ON c.ancestry = CAST(categories.id AS text)
   OR c.ancestry = categories.ancestry || '/' || categories.id").group('categories.id').having('COUNT(c.id) = 0')
  }

  scope :with_combos, -> { joins(:categories).distinct }

  scope :without_combos, -> { where.not(id: Combo.pluck(:category_id).uniq) }

  validates :name, presence: :true
  validate :depth_smaller_than_five
  has_many :combos

  def base_category_id
    parent_id.present? ? parent_id : id
  end

  def subcategory_id
    parent_id.present? ? id : nil
  end

  def base_category
    parent_id.present? ? parent : self
  end

  def subcategory
    parent_id.present? ? self : nil
  end

  def combos?
    combos.count.positive?
  end

  def to_s
    name
  end

  private

  def depth_smaller_than_five
    return if parent.nil?
    return if parent.parent.nil?
    return if parent.parent.parent.nil?
    return if parent.parent.parent.parent.nil?
    errors.add(:base, 'No debe haber más de cuatro niveles de subcategorías')
  end
end
