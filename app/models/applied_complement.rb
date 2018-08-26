# == Schema Information
#
# Table name: applied_complements
#
#  id            :integer          not null, primary key
#  complement_id :integer          not null
#  taxon_id      :integer          not null
#  quantity      :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AppliedComplement < ActiveRecord::Base
  belongs_to :complement
  belongs_to :taxon, class_name: 'Spree::Taxon'

  def name
    complement.name
  end
end
