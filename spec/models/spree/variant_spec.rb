require 'rails_helper'

RSpec.describe Spree::Variant do
  let(:variant) { create :variant }
  
  context 'al crear un variant' do
    it 'se persiste en la db' do
      expect(variant).to be_persisted
    end
  end
end
