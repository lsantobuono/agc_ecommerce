require 'rails_helper'

RSpec.describe Spree::Variant do
  let(:variant) { create :variant, is_master: true }

  before do
    create :stock_location
  end

  context 'al crear un variant' do
    it 'se persiste en la db' do
      expect(variant).to be_persisted
    end

    it 'no tiene product' do
      expect(variant.product).to be_nil
    end

    it 'tiene un stock_item' do
      expect(variant.stock_items.count).to eq 1
    end
  end
end
