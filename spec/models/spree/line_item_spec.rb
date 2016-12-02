require 'rails_helper'

RSpec.describe Spree::LineItem do
  let(:order) { create :order }
  let(:line_item) { create :line_item, order: order }
  
  before do
    create :stock_location
  end

  context 'al crear un line_item' do
    it 'se persiste en la db' do
      expect(line_item).to be_persisted
    end

    it do
      expect(line_item.price).to be > 0
    end
  end
end
