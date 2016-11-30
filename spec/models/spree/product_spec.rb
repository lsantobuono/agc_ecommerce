require 'rails_helper'

RSpec.describe Spree::Product do
  let(:product) { create :product }
  
  context 'al crear un product' do
    it 'se persiste en la db' do
      expect(product).to be_persisted
    end
  end
end
