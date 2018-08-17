class AppliedComplement < ActiveRecord::Base
  belongs_to :complement
  belongs_to :taxon, class_name: 'Spree::Taxon'
end
