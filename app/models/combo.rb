class Combo < ActiveRecord::Base
  acts_as_paranoid

  has_many :combo_lines

  validates :name, :code, presence: true
  validates :name, :code, uniqueness: true
end
