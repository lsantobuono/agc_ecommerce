class AppliedComplement < ActiveRecord::Base
  belongs_to :complement
  belongs_to :taxon, class_name: 'Spree::Taxon'

  def name
    complement.name
  end
end
