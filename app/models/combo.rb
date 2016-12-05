class Combo < ActiveRecord::Base
  acts_as_paranoid

  has_many :combo_lines
  accepts_nested_attributes_for :combo_lines, allow_destroy: true

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
end
